//
//  BiometricAuthManager.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import Foundation
import LocalAuthentication

final class BiometricAuthManager {
    func authenticate() async throws {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw error ?? NSError(domain: "Biometric",code:-1)
        }
        
        try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorize Secure NVMe Hosting")
    }
}

