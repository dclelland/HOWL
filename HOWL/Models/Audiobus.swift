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
    
    // MARK: Shared client
    
    static var client: Audiobus? = {
        guard let apiKey = apiKey else {
            return nil
        }
        
        return Audiobus(apiKey: apiKey)
    }()
    
    private static var apiKey: String? = {
        guard let path = NSBundle.mainBundle().pathForResource("audiobus", ofType: "txt") else {
            return nil
        }
        
        do {
            return try String(contentsOfFile: path)
        } catch {
            return nil
        }
    }()
    
    // MARK: Variables
    
    var apiKey: String
    
    lazy var controller: ABAudiobusController = {
        return ABAudiobusController(apiKey: apiKey)
    }()
        
    lazy var senderPort: ABSenderPort = {
        return ABSenderPort(
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
    }()
    
    lazy var filterPort: ABFilterPort = {
        return ABFilterPort(
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
    }()
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: Actions
    
    mutating func start() {
        NSNotificationCenter.defaultCenter().addObserverForName(ABConnectionsChangedNotification, object: nil, queue: nil, usingBlock: { (notification) in
            self.connectionsChanged(notification)
        })
        
        controller.addSenderPort(senderPort)
        controller.addFilterPort(filterPort)
    }
    
    // MARK: Notifications
    
    private mutating func connectionsChanged(notification: NSNotification) {
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
