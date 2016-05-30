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
        AKSettings.shared().playbackWhileMuted = true
        
        Audio.start()
        Audio.play()
        
        setupAudiobus()
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if (AKManager.sharedManager().isRunning == false) {
            Audio.start()
            Audio.play()
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        if (audiobusController?.connected != true && audiobusController?.memberOfActiveAudiobusSession != true) {
            Audio.stop()
        }
    }

}

// MARK: - Audiobus

extension AppDelegate {
    
    private func setupAudiobus() {
        if let apiKey = self.apiKey {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(audiobusConnectionsChanged(_:)), name: ABConnectionsChangedNotification, object: nil)
            
            audiobusController = ABAudiobusController(apiKey: apiKey)
            audiobusController?.connectionPanelPosition = ABConnectionPanelPositionRight
            
            audiobusController?.addObserver(self, forKeyPath: "connected", options: [.New], context: nil)
            audiobusController?.addObserver(self, forKeyPath: "memberOfActiveAudiobusSession", options: [.New], context: nil)
            
            let vocoderDescription = AudioComponentDescription(
                componentType: kAudioUnitType_RemoteEffect,
                componentSubType: "voco".code!,
                componentManufacturer: "ptnm".code!,
                componentFlags: 0,
                componentFlagsMask: 0
            )
            
            let synthesizerDescription = AudioComponentDescription(
                componentType: kAudioUnitType_RemoteGenerator,
                componentSubType: "synt".code!,
                componentManufacturer: "ptnm".code!,
                componentFlags: 0,
                componentFlagsMask: 0
            )
            
            let vocoderPort = ABFilterPort(
                name: "Vocoder",
                title: "HOWL: Vocoder",
                audioComponentDescription: vocoderDescription,
                audioUnit: audioUnit
            )
            
            let synthesizerPort = ABSenderPort(
                name: "Synthesizer",
                title: "HOWL: Synthesizer",
                audioComponentDescription: synthesizerDescription,
                audioUnit: audioUnit
            )
            
            audiobusController?.addFilterPort(vocoderPort)
            audiobusController?.addSenderPort(synthesizerPort)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // This needs cleaning...
//        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        
        if (keyPath == "connected" || keyPath == "memberOfActiveAudiobusSession") {
            if (UIApplication.sharedApplication().applicationState == .Background && audiobusController?.connected != true && audiobusController?.memberOfActiveAudiobusSession != true) {
                Audio.stop()
            }
        }
    }
    
    internal func audiobusConnectionsChanged(notification: NSNotification) {
        if (audiobusController?.connected == true && AKManager.sharedManager().isRunning == false) {
//        if (audiobusController?.connected == true) {
            Audio.start()
            Audio.play()
        }
    }
    
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
    
    private var audioUnit: AudioUnit {
        // need better way of doing this, too
        return AKManager.sharedManager().engine.audioUnit
    }
    
}
