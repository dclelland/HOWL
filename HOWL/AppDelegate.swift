//
//  AppDelegate.swift
//  HOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import AudioKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AKSettings.shared().playbackWhileMuted = true
        
        Audio.start()
        Audio.play()
        
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

