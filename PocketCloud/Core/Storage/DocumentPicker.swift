//
//  DocumentPicker.swift
//  PocketCloud
//
//  Created by CU_Student21 on 02/04/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    
    var onPick: (URL) -> Void   // callback
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPick: onPick)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        picker.delegate = context.coordinator
        return picker
    }
    func copyWebUIToDocuments() {
        let fileManager = FileManager.default
        
        guard let bundlePath = Bundle.main.resourcePath?.appending("/WebUI") else { return }
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = documents.appendingPathComponent("WebUI")
        
        if !fileManager.fileExists(atPath: dest.path) {
            try? fileManager.copyItem(atPath: bundlePath, toPath: dest.path)
        }
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        
        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                onPick(url)
            }
        }
    }
}
