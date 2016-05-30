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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var audiobusController: ABAudiobusController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AKSettings.shared().playbackWhileMuted = true
        
        Audio.start()
        Audio.play()
        
        if let apiKey = self.apiKey {
            audiobusController = ABAudiobusController(apiKey: apiKey)
            audiobusController?.connectionPanelPosition = ABConnectionPanelPositionRight
        }
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if (Audio.stopsInBackground) {
            Audio.start()
            Audio.play()
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        if (Audio.stopsInBackground) {
            Audio.stop()
        }
    }

}

// MARK: - Private helpers

private extension AppDelegate {
    
    var apiKey: String? {
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

