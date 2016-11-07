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

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        AKSettings.audioInputEnabled = true
        AKSettings.playbackWhileMuted = true
        AKSettings.defaultToSpeaker = false
        
        Audio.client.start()
//        Audiobus.start()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        Audio.start()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        if (Audiobus.client?.isConnected == false && Settings.sustained == false) {
//            Audio.stop()
//        }
    }

}
