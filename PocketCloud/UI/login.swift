//
//  login.swift
//  PocketCloud
//
//  Created by ashmit on 26/03/26.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showLoginFields = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var biometricType = "Face ID"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            if showLoginFields {
                // Email Field
                TextField("Enter Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Password Field
                SecureField("Enter Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Login") {
                    loginWithCredentials()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Button("Login with \(biometricType)") {
                    authenticateUser()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
        }
        .padding()
        .onAppear {
            detectBiometricType()
            authenticateUser() // auto-trigger Face ID
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Detect Face ID / Touch ID
    func detectBiometricType() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                biometricType = "Face ID"
            case .touchID:
                biometricType = "Touch ID"
            default:
                biometricType = "Biometric"
            }
        }
    }
    
    // Face ID Authentication
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Login using \(biometricType)"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                
                DispatchQueue.main.async {
                    if success {
                        alertMessage = "Login Successful via \(biometricType) ✅"
                        showAlert = true
                    } else {
                        // Fallback to email/password
                        showLoginFields = true
                        alertMessage = "\(biometricType) Failed. Use Email & Password."
                        showAlert = true
                    }
                }
            }
            
        } else {
            // No biometrics → directly show login fields
            showLoginFields = true
        }
    }
    
    // Email + Password Login
    func loginWithCredentials() {
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        let savedPassword = UserDefaults.standard.string(forKey: "userPassword")
        
        if email == savedEmail && password == savedPassword {
            alertMessage = "Login Successful 🎉"
        } else {
            alertMessage = "Invalid Credentials ❌"
        }
        
        showAlert = true
    }
}

#Preview {
    LoginView()
}
