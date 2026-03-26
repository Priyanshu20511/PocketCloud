//
//  HostingState.swift
//  PocketCloud
//
//  Created by CU_Student21 on 26/02/26.
//

enum HostingState {
    case idle
    case verifyingPower
    case authenticating
    case generatingToken
    case startingServer
    case active
    case terminating(reason: TerminationReason)
}

enum TerminationReason {
    case unplugged
    case timeout
    case manual
    case authenticationFailed
}
