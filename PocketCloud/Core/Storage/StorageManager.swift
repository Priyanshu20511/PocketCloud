//
//  StorageManager.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import Combine
import Foundation
import UniformTypeIdentifiers

final class StorageManager: ObservableObject {
    
    @Published private(set) var rootURL: URL?
    
    private let bookmarkKey = "NVMeBookmark"
    
    // MARK: - Select External Folder
    
    func setRootURL(_ url: URL) throws {
#if os(macOS)
        let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        rootURL = url
#else
        // Security-scoped bookmarks are unavailable on iOS. Persist a standard bookmark or the path.
        let bookmark = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        rootURL = url
#endif
    }
    
    // MARK: - Restore Access
    
    func restoreAccess() -> Bool {
#if os(macOS)
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey) else {
            return false
        }
        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: bookmarkData,
                              options: .withSecurityScope,
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            if url.startAccessingSecurityScopedResource() {
                rootURL = url
                return true
            }
        } catch {
            print("Bookmark restore failed:", error)
        }
        return false
#else
        // On iOS, security-scoped bookmarks are unavailable. Resolve a standard bookmark without security scope.
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey) else {
            return false
        }
        var isStale = false
        do{
            let url = try URL(resolvingBookmarkData: bookmarkData,
                              options: [],
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            // No need to start security-scoped access on iOS.
            rootURL = url
            return true
        } catch {
            print("Bookmark restore failed:", error)
            return false
        }
#endif
    }
    
    // MARK: - List Files
    
    func listFiles() -> [URL] {
        guard let rootURL else { return [] }
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: rootURL, includingPropertiesForKeys: [.isDirectoryKey, .contentModificationDateKey], options: [.skipsHiddenFiles])
            return contents
        } catch {
            print("Failed to list files at \(rootURL):", error)
            return []
        }
    }
}
