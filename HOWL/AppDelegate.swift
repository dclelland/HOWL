//
//  AppDelegate.swift
//  HOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import AudioKit
import AudioToolbox
import LVGFourCharCodes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var audiobusController: ABAudiobusController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("APPLICATION DID FINISH LAUNCHING WITH OPTIONS")
        AKSettings.shared().audioInputEnabled = true
        AKSettings.shared().playbackWhileMuted = true
        AKSettings.shared().defaultToSpeaker = false
        
        startAudio()
        startAudiobus()
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("APPLICATION WILL ENTER FOREGROUND")
        printAudiobusStatus()
        startAudio()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("APPLICATION DID ENTER BACKGROUND")
        printAudiobusStatus()
        if (audiobusController?.connected == false && audiobusController?.memberOfActiveAudiobusSession == false) {
            stopAudio()
        }
    }
    
    // MARK: Notifications
    
    func audiobusConnectionsChanged(notification: NSNotification) {
        print("AUDIOBUS CONNECTIONS CHANGED")
        printAudiobusStatus()
        if (UIApplication.sharedApplication().applicationState == .Background) {
            if (audiobusController?.connected == false && audiobusController?.memberOfActiveAudiobusSession == false) {
                stopAudio()
            } else {
                startAudio()
            }
        }
        
        if (audiobusController?.inputConnected == true) {
            print("UNMUTING MIC")
            Audio.synthesizer.unmuteMicrophone()
        } else {
            print("MUTING MIC")
            Audio.synthesizer.muteMicrophone()
        }
    }

    // MARK: Audio

    private func startAudio() {
        if (AKManager.sharedManager().isRunning == false) {
            print("STARTING AUDIO")
            printAudiobusStatus()
            Audio.start()
            Audio.play()
        }
    }
    
    private func stopAudio() {
        if (AKManager.sharedManager().isRunning == true && Audio.sustained == false) {
            print("STOPPING AUDIO")
            printAudiobusStatus()
            Audio.stop()
        }
    }
    
    // MARK: Logging
    
    private func printAudiobusStatus() {
        if let audiobusController = audiobusController {
            print("connected == \(audiobusController.connected), memberOfActiveAudiobusSession == \(audiobusController.memberOfActiveAudiobusSession)")
            print("connectedPorts == \(audiobusController.connectedPorts)")
        }
    }

}

// MARK: - Audiobus

extension AppDelegate {
    
    private func startAudiobus() {
        if let apiKey = self.audiobusApiKey {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(audiobusConnectionsChanged(_:)), name: ABConnectionsChangedNotification, object: nil)
            
            audiobusController = ABAudiobusController(apiKey: apiKey)
            
            audiobusController?.addSenderPort(audiobusSenderPort)
            audiobusController?.addFilterPort(audiobusFilterPort)
        }
    }
    
    // MARK: Audiobus properties
    
    private var audiobusSenderPort: ABSenderPort {
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
            audioUnit: audiobusAudioUnit
        )
    }
    
    private var audiobusFilterPort: ABFilterPort {
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
            audioUnit: audiobusAudioUnit
        )
    }
    
    private var audiobusAudioUnit: AudioUnit {
        return AKManager.sharedManager().engine.audioUnit
    }
    
    private var audiobusApiKey: String? {
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

private extension ABAudiobusController {
    
    var inputConnected: Bool {
        return connectedPorts.map { $0 as! ABPort }.filter { $0.type == ABPortTypeSender }.isEmpty == false
    }
    
}
