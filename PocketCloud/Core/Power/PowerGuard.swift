//
//  PowerGuard.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

import SwiftUI
import Combine
import Foundation

final class PowerGuard: ObservableObject{
    
    @Published private(set) var isCharging: Bool = false
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateState()
        NotificationCenter.default.addObserver(self, selector: #selector(updateState), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc private func updateState(){
        let state = UIDevice.current.batteryState
        isCharging = (state == .charging || state == .full)
    }
}
