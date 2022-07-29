//
//  DarwinNotificationCenter.swift
//  Broadcast Extension
//
//  Created by Alex-Dan Bumbu on 23/03/2021.
//  Copyright © 2021 8x8, Inc. All rights reserved.
//

import Foundation

enum DarwinNotification: String {
    case broadcastStarted = "RemoteEye_BroadcastStarted"
    case broadcastStopped = "RemoteEye_BroadcastStopped"
    case stopScreenShareBroadcast = "RemoteEye_StopBroadcast"
}

class DarwinNotificationCenter {
    
    static let shared = DarwinNotificationCenter()
    
    let notificationCenter: CFNotificationCenter
    
    init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }
    
    func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: name.rawValue as CFString), nil, nil, true)
    }
}
