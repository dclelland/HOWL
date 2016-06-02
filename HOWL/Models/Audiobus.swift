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
    
    // MARK: Shared
    
    static var client = Audiobus()
    
    // MARK: Variables
    
    lazy var controller: ABAudiobusController? = {
        guard let apiKey = self.apiKey else {
            return nil
        }
        
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
    
    // MARK: Actions
    
    mutating func start() {
        if let controller = controller {
            NSNotificationCenter.defaultCenter().addObserverForName(ABConnectionsChangedNotification, object: nil, queue: nil, usingBlock: { (notification) in
                self.connectionsChanged(notification)
            })
            
            controller.addSenderPort(senderPort)
            controller.addFilterPort(filterPort)
        }
    }
    
    // MARK: Notifications
    
    private mutating func connectionsChanged(notification: NSNotification) {
        if (UIApplication.sharedApplication().applicationState == .Background) {
            if (controller?.isConnected == true) {
                Audio.start()
            } else {
                Audio.stop()
            }
        }
        
        if (controller?.isConnectedToSender == true) {
            Audio.synthesizer.unmuteMicrophone()
        } else {
            Audio.synthesizer.muteMicrophone()
        }
    }
    
    // MARK: - Private properties
    
    private var apiKey: String? {
        guard let path = NSBundle.mainBundle().pathForResource("audiobus", ofType: "txt") else {
            return nil
        }
        
        do {
            return try String(contentsOfFile: path)
        } catch {
            return nil
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
