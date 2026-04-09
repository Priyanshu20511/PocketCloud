//
//  ServerManager.swift
//  PocketCloud
//
//  Created by CU_Student21 on 02/04/26.
//

import Foundation
import GCDWebServer
import Combine

class ServerManager: ObservableObject {
    private var webServer = GCDWebServer()
    
    
    @Published var serverURL: String = "Server not running"
    
    func startServer() {
        
        webServer.removeAllHandlers()
        guard let indexPath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "WebUI") else {
            print("index.html NOT FOUND ❌")
            return
        }
        
        let folderPath = (indexPath as NSString).deletingLastPathComponent
        
        print("Serving from:", folderPath)
        
        webServer.addGETHandler(
            forBasePath: "/",
            directoryPath: folderPath,
            indexFilename: "index.html",
            cacheAge: 3600,
            allowRangeRequests: true
        )
        
        do {
            try webServer.start(options: [
                GCDWebServerOption_Port: 8000,
                GCDWebServerOption_BindToLocalhost: false
            ])
            
            print("Server running at:", webServer.serverURL ?? "nil")
            
            serverURL = webServer.serverURL?.absoluteString ?? "Error"
            
        } catch {
            print("Server failed:", error)
            serverURL = "Failed to start"
        }
    }
    
    func stopServer() {
        webServer.stop()
        serverURL = "Server stopped"
    }
}

