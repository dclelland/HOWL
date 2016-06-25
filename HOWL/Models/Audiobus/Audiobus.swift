//
//  Audiobus.swift
//  HOWL
//
//  Created by Daniel Clelland on 2/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Audiobus {
    
    // MARK: Client
    
    static var client: Audiobus?
    
    // MARK: Actions
    
    static func start() {
        guard client == nil else {
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
    
    var audioUnit: AudioUnit {
        return AKManager.sharedManager().engine.audioUnit
    }
    
    private var audioUnitPropertyListener: AudioUnitPropertyListener!

    init(apiKey: String) {
        self.controller = ABAudiobusController(apiKey: apiKey)
        
        self.controller.addSenderPort(
            ABSenderPort(
                name: "Sender",
                title: "HOWL (Sender)",
                audioComponentDescription: AudioComponentDescription(
                    componentType: kAudioUnitType_RemoteGenerator,
                    componentSubType: UInt32(fourCharacterCode: "howg"),
                    componentManufacturer: UInt32(fourCharacterCode: "ptnm"),
                    componentFlags: 0,
                    componentFlagsMask: 0
                ),
                audioUnit: AKManager.sharedManager().engine.audioUnit
            )
        )
        
        self.controller.addFilterPort(
            ABFilterPort(
                name: "Filter",
                title: "HOWL (Filter)",
                audioComponentDescription: AudioComponentDescription(
                    componentType: kAudioUnitType_RemoteEffect,
                    componentSubType: UInt32(fourCharacterCode: "howx"),
                    componentManufacturer: UInt32(fourCharacterCode: "ptnm"),
                    componentFlags: 0,
                    componentFlagsMask: 0
                ),
                audioUnit: AKManager.sharedManager().engine.audioUnit
            )
        )
        
        self.audioUnitPropertyListener = AudioUnitPropertyListener { (audioUnit, property) in
            switch property {
            case kAudioUnitProperty_IsInterAppConnected:
                self.updateConnections()
            case kAudioOutputUnitProperty_NodeComponentDescription:
                self.updateConnections()
            default:
                break
            }
        }
        
        self.audioUnit.add(listener: self.audioUnitPropertyListener, toProperty: kAudioUnitProperty_IsInterAppConnected)
        self.audioUnit.add(listener: self.audioUnitPropertyListener, toProperty: kAudioOutputUnitProperty_NodeComponentDescription)
        
        NSNotificationCenter.defaultCenter().addObserverForName(ABConnectionsChangedNotification, object: nil, queue: nil, usingBlock: { notification in
            self.updateConnections()
        })
    }
    
    deinit {
        AKManager.sharedManager().engine.audioUnit.remove(listener: self.audioUnitPropertyListener, fromProperty: kAudioUnitProperty_IsInterAppConnected)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ABConnectionsChangedNotification, object: nil)
    }
    
    // MARK: Properties
    
    var isConnected: Bool {
        return controller.isConnectedToAudiobus || audioUnit.isConnectedToInterAppAudio
    }
    
    var isConnectedToInput: Bool {
        return controller.isConnectedToAudiobus(portOfType: ABPortTypeSender) || audioUnit.isConnectedToInterAppAudio(nodeOfType: kAudioUnitType_RemoteEffect)
    }
    
    // MARK: Notifications
    
    private func updateConnections() {
        if (UIApplication.sharedApplication().applicationState == .Background) {
            if (isConnected) {
                Audio.start()
            } else {
                Audio.stop()
            }
        }
        
        if (isConnectedToInput) {
            Audio.client?.vocoder.inputEnabled = true
        }
    }

}

private extension ABAudiobusController {
    
    var isConnectedToAudiobus: Bool {
        return connected == true || memberOfActiveAudiobusSession == true
    }
    
    func isConnectedToAudiobus(portOfType type: ABPortType) -> Bool {
        guard connectedPorts != nil else {
            return false
        }
        
        return connectedPorts.flatMap { $0 as? ABPort }.filter { $0.type == type }.isEmpty == false
    }
    
}

private extension AudioUnit {
    
    var isConnectedToInterAppAudio: Bool {
        let value: UInt32 = getValue(forProperty: kAudioUnitProperty_IsInterAppConnected)
        return value != 0
    }
    
    func isConnectedToInterAppAudio(nodeOfType type: OSType) -> Bool {
        let value: AudioComponentDescription = getValue(forProperty: kAudioOutputUnitProperty_NodeComponentDescription)
        return value.componentType == type
    }
    
}
