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
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Register")
                .font(.largeTitle)
                .bold()
            
            // Email Field
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            // Password Field
            SecureField("Enter Password (Recovery)", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Enable Biometric Button
            Button(action: {
                enableBiometric()
            }) {
                Text("Register Fingerprint / Face ID")
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Biometric Function
    func enableBiometric() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable biometric authentication") { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        isBiometricEnabled = true
                        alertMessage = "Biometric Registered Successfully ✅"
                    } else {
                        alertMessage = "Biometric Failed ❌"
                    }
                    showAlert = true
                }
            }
            
        } else {
            alertMessage = "Biometric not available on this device"
            showAlert = true
        }
    }
    
    // MARK: - Register User
    func registerUser() {
        
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill all fields"
            showAlert = true
            return
        }
        
        if !isBiometricEnabled {
            alertMessage = "Please enable biometric authentication"
            showAlert = true
            return
        }
        
        // Save data (for demo: UserDefaults)
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
