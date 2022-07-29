//
//  SampleHandler.swift
//  SampleHandlerTestExtension
//
//  Created by Jaswant Singh on 25/07/22.
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {
    
    private var clientSocket: RongRTCClientSocket?
    override init() {
        super.init()
        
        
    }
    
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        clientSocket = RongRTCClientSocket()
        clientSocket?.createCliectSocket()
        
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        setupDarwinBroadcastReceivers()
        setupNotificationObservers()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        stopSocket()
        // User has requested to finish the broadcast.
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            sendData(sampleBuffer)
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
    
    func sendData(_ sampleBuffer: CMSampleBuffer) {
        self.clientSocket?.encode(sampleBuffer)
    }
    
    private func setupDarwinBroadcastReceivers() {
        CFNotificationCenterAddObserver(DarwinNotificationCenter.shared.notificationCenter, nil, notificationCallback, DarwinNotification.stopScreenShareBroadcast.rawValue as CFString, nil, .deliverImmediately)
    }
    
    
    private let notificationCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let notificationReceivedWithName = cfName?.rawValue as String? else {
            return
        }
        print(notificationReceivedWithName)
        
        if(notificationReceivedWithName == DarwinNotification.stopScreenShareBroadcast.rawValue) {
            NotificationCenter.default.post(name: STOP_SCREEN_SHARE_NOTIFICATION, object: nil, userInfo:["message" : "stop_screen_share"])
        }
    }
}

private extension SampleHandler {

    func stopSocket() {
        self.clientSocket?.close()
        self.clientSocket = nil
    }
    
    func endBroadcast() {
        let userInfo = [NSLocalizedFailureReasonErrorKey: "Screenshare has been ended by you."]
        let err = NSError(domain: "ScreenShare", code: -1, userInfo: userInfo)
        finishBroadcastWithError(err)
    }
}

private extension SampleHandler {
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: STOP_SCREEN_SHARE_NOTIFICATION, object: nil)
    }
    
    @objc func onNotification(notification:Notification) {
        print("onNotification")
        if(notification.name == STOP_SCREEN_SHARE_NOTIFICATION) {
            self.stopSocket()
            self.endBroadcast()
        }
    }
}
