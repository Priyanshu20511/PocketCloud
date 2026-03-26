//
//  DashboardView.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var storageManager = StorageManager()
    @StateObject private var powerGuard = PowerGuard()
    @StateObject private var sessionManager = SessionManager()
    @State private var showPicker = false
    
    private let authManager = BiometricAuthManager()
    private let tokenManager = TokenManager()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Charging: \(powerGuard.isCharging ? "YES" : "NO")")
            
            Button("Start Secure Hosting") {
                Task {
                    await startHosting()
                }
            }
            
            Text("State: \(String(describing: sessionManager.state))")
        }
        .padding()
    }
    
    private func startHosting() async {
        
        guard powerGuard.isCharging else {
            sessionManager.terminate(reason: .unplugged)
            return
        }
        
        do {
            try await authManager.authenticate()
            let token = tokenManager.generateToken()
            print("Generated Token:", token)
            
            sessionManager.startSession {
                print("Session Timeout")
            }
            
        } catch {
            sessionManager.terminate(reason: .authenticationFailed)
        }
    }
    
//    Button("Select NVMe Folder"){
//        showPicker = true
//    }
    
}
#Preview {
    DashboardView()
}
