//
//  register.swift
//  PocketCloud
//
//  Created by Ashmit on 26/03/26.
//
import SwiftUI
import LocalAuthentication

struct RegisterView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isBiometricEnabled = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var biometricType = "Biometric"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Register")
                .font(.largeTitle)
                .bold()
            
            // Email
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            // Password
            SecureField("Enter Password (Recovery)", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Face ID Button
            Button(action: {
                enableBiometric()
            }) {
                Text("Register with \(biometricType)")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Register Button
            Button(action: {
                registerUser()
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
        }
        .padding()
        .onAppear {
            detectBiometricType()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Detect Face ID or Touch ID
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
    
    // Enable Face ID
    func enableBiometric() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Register using \(biometricType)"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                
                DispatchQueue.main.async {
                    if success {
                        isBiometricEnabled = true
                        alertMessage = "\(biometricType) Enabled ✅"
                    } else {
                        alertMessage = "\(biometricType) Failed ❌"
                    }
                    showAlert = true
                }
            }
        } else {
            alertMessage = "Biometric not available"
            showAlert = true
        }
    }
    
    // Register
    func registerUser() {
        
        if email.isEmpty || password.isEmpty {
            alertMessage = "Fill all fields"
            showAlert = true
            return
        }
        
        if !isBiometricEnabled {
            alertMessage = "Enable Face ID first"
            showAlert = true
            return
        }
        
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        UserDefaults.standard.set(true, forKey: "biometricEnabled")
        
        alertMessage = "Registration Successful 🎉"
        showAlert = true
    }
}

#Preview {
    RegisterView()
}
