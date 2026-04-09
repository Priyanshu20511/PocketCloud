//
//  ContentView.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var server = ServerManager()
    @State private var showPicker = false
    var body: some View {
        VStack(spacing: 20) {
            
            Text("PocketCloud")
                .font(.largeTitle)
            
            Text(server.serverURL)
                .foregroundColor(.blue)
                .padding()
            
            Button("Start Server") {
                server.startServer()
            }
            
            Button("Stop Server") {
                server.stopServer()
            }
            Button("Upload File") {
                showPicker = true
            }
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            DocumentPicker { url in saveFileToDocuments(from: url)}
        }
    }
    func saveFileToDocuments(from url: URL) {
        let fileManager = FileManager.default
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destination = documents.appendingPathComponent(url.lastPathComponent)
        
        do {
            // Required for external files (NVMe / Files app)
            let shouldStop = url.startAccessingSecurityScopedResource()
            
            defer {
                if shouldStop {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            
            try fileManager.copyItem(at: url, to: destination)
            
            print("File saved to:", destination)
            
        } catch {
            print("Error saving file:", error)
        }
    }
    
}

#Preview {
    ContentView()
}
