//
//  ViewController.swift
//  SampleHandlerTest
//
//  Created by Jaswant Singh on 25/07/22.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {

    private var broadcastPickerView: RPSystemBroadcastPickerView? = nil
    private var serverSocket: RongRTCServerSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupServerSocket()
        self.setupReplayKitPicker()
        self.setupDarvinNotificaions()
    }
    
    private func setupReplayKitPicker() {
        
//        broadcastPickerView = RPSystemBroadcastPickerView.init(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 80))
//        broadcastPickerView?.preferredExtension = "com.thirdeyegen.mrworkspace.SampleHandlerTest.SampleHandlerTestExtension"
//        broadcastPickerView?.backgroundColor = UIColor(red: 53.0/255, green: 129.0/255, blue: 242.0/255, alpha: 1.0 )
//        broadcastPickerView?.showsMicrophoneButton = false
//        self.view.addSubview(broadcastPickerView!)
    }
    
    private func setupServerSocket() {
        if(serverSocket == nil) {
            let socket = RongRTCServerSocket()
            socket.delegate = self
            serverSocket = socket
            serverSocket?.createServerSocket()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        serverSocket?.close()
        serverSocket = nil
    }
    
    private func setupDarvinNotificaions() {
        CFNotificationCenterAddObserver(DarwinNotificationCenter.shared.notificationCenter, nil, notificationCallback, DarwinNotification.broadcastStarted.rawValue as CFString, nil, .deliverImmediately)
        CFNotificationCenterAddObserver(DarwinNotificationCenter.shared.notificationCenter, nil, notificationCallback, DarwinNotification.broadcastStopped.rawValue as CFString, nil, .deliverImmediately)
    }
    
    private let notificationCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let receivedNotificationName = cfName?.rawValue as String? else {
            return
        }
        
        print(receivedNotificationName)

        print("how many times?")
    }
    
    @IBAction func onStartScreenShareClicked(_ sender: Any) {
        let pickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y:0, width: 50, height: 50))
        pickerView.preferredExtension = "com.thirdeyegen.mrworkspace.SampleHandlerTest.SampleHandlerTestExtension"
        pickerView.showsMicrophoneButton = false
                            
        // Auto click RPSystemBroadcastPickerView
        for view in pickerView.subviews {
            let startButton = view as! UIButton
            startButton.sendActions(for: .allTouchEvents)
        }
    }
    
    @IBAction func onStopScreenShareClicked(_ sender: Any) {
        DarwinNotificationCenter.shared.postNotification(.stopScreenShareBroadcast)
    }
}



extension ViewController: RongRTCServerSocketProtocol {
    
    func stoppedReceingBuffer() {
        print("Screen share ended")
        self.serverSocket?.close()
        self.serverSocket = nil
        self.setupServerSocket()
    }
    
    func didProcessSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        print("Frame Captured")
    }
}

