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
        
        startObservingInterAppAudioConnections()
        startObservingAudiobusConnections()
    }
    
    deinit {
        stopObservingInterAppAudioConnections()
        stopObservingAudiobusConnections()
    }
    
    // MARK: Properties
    
    var isConnected: Bool {
        return controller.isConnectedToAudiobus || audioUnit.isConnectedToInterAppAudio
    }
    
    // MARK: Connections
    
    private var audioUnitPropertyListener: AudioUnitPropertyListener!
    
    private func startObservingInterAppAudioConnections() {
        audioUnitPropertyListener = AudioUnitPropertyListener { (audioUnit, property) in
            self.updateConnections()
        }
        
        audioUnit.add(listener: audioUnitPropertyListener, toProperty: kAudioUnitProperty_IsInterAppConnected)
    }
    
    private func stopObservingInterAppAudioConnections() {
        AKManager.sharedManager().engine.audioUnit.remove(listener: self.audioUnitPropertyListener, fromProperty: kAudioUnitProperty_IsInterAppConnected)
    }
    
    private func startObservingAudiobusConnections() {
        NSNotificationCenter.defaultCenter().addObserverForName(ABConnectionsChangedNotification, object: nil, queue: nil, usingBlock: { notification in
            self.updateConnections()
        })
    }
    
    private func stopObservingAudiobusConnections() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ABConnectionsChangedNotification, object: nil)
    }
    
    private func updateConnections() {
        if (UIApplication.sharedApplication().applicationState == .Background) {
            if (isConnected) {
                Audio.start()
            } else {
                Audio.stop()
            }
        }
    }

}

private extension ABAudiobusController {
    
    var isConnectedToAudiobus: Bool {
        return connected == true || memberOfActiveAudiobusSession == true
    }
    
}

private extension AudioUnit {
    
    var isConnectedToInterAppAudio: Bool {
        let value: UInt32 = getValue(forProperty: kAudioUnitProperty_IsInterAppConnected)
        return value != 0
    }
    
}
