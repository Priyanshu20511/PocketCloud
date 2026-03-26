//
//  TokenManager.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import Foundation
import CryptoKit

final class TokenManager {
    
    func generateToken() -> String {
        let randomData = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        let hash = SHA256.hash(data: randomData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
