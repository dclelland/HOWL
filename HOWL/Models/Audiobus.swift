//
//  Audiobus.swift
//  HOWL
//
//  Created by Daniel Clelland on 2/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit
import LVGFourCharCodes

struct Audiobus {
    
    // MARK: Client
    
    static var client: Audiobus?
    
    // MARK: Actions
    
    static func start() {
        guard client != nil else {
            return
        }
        
        if let apiKey = apiKey {
            client = Audiobus(apiKey: apiKey)
        }
    }
    
    private static var apiKey: String? {
        guard let path = NSBundle.mainBundle().pathForResource("audiobus", ofType: "txt") else {
            return nil
        }
        
        do {
            return try String(contentsOfFile: path)
        } catch {
            return nil
        }
    }
    
    // MARK: Initialization
    
    var controller: ABAudiobusController

    init(apiKey: String) {
        self.controller = ABAudiobusController(apiKey: apiKey)
        
        self.controller.addSenderPort(ABSenderPort(
            name: "Synthesizer",
            title: "HOWL: Synthesizer",
            audioComponentDescription: AudioComponentDescription(
                componentType: kAudioUnitType_RemoteGenerator,
                componentSubType: "synt".code!,
                componentManufacturer: "ptnm".code!,
                componentFlags: 0,
                componentFlagsMask: 0
            ),
            audioUnit: AKManager.sharedManager().engine.audioUnit
            )
        )
        
        self.controller.addFilterPort(ABFilterPort(
            name: "Vocoder",
            title: "HOWL: Vocoder",
            audioComponentDescription: AudioComponentDescription(
                componentType: kAudioUnitType_RemoteEffect,
                componentSubType: "voco".code!,
                componentManufacturer: "ptnm".code!,
                componentFlags: 0,
                componentFlagsMask: 0
            ),
            audioUnit: AKManager.sharedManager().engine.audioUnit
            )
        )
        
        NSNotificationCenter.defaultCenter().addObserverForName(ABConnectionsChangedNotification, object: nil, queue: nil, usingBlock: { (notification) in
            self.connectionsChanged(notification)
        })
    }
    
    // MARK: Notifications
    
    private func connectionsChanged(notification: NSNotification) {
        if (UIApplication.sharedApplication().applicationState == .Background) {
            if (controller.isConnected) {
                Audio.start()
            } else {
                Audio.stop()
            }
        }
        
        if (controller.isConnectedToSender) {
            Audio.synthesizer.unmuteMicrophone()
        } else {
            Audio.synthesizer.muteMicrophone()
        }
    }

}

extension ABAudiobusController {
    
    var isConnected: Bool {
        return connected == true || memberOfActiveAudiobusSession == true
    }
    
    var isConnectedToSender: Bool {
        return connectedPorts.map { $0 as! ABPort }.filter { $0.type == ABPortTypeSender }.isEmpty == false
    }
    
}
