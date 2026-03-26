//
//  SessionManager.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import Combine
import Foundation


final class SessionManager: ObservableObject {
    
    @Published private(set) var state: HostingState = .idle
    private var timer: Timer?
    
    func startSession(timeout: TimeInterval = 900, onTimeout: @escaping () -> Void) {
        state = .active
        
        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
            self.state = .terminating(reason: .timeout)
            onTimeout()
        }
    }
    
    func terminate(reason: TerminationReason) {
        timer?.invalidate()
        state = .terminating(reason: reason)
    }
}
