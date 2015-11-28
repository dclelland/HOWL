//
//  Settings.swift
//  VOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Settings {
    
    static let shared = Settings()
    
    static let keyboardSustainKey = "keyboardSustainKey"
    static let phonemeboardSustainKey = "phonemeboardSustain"
    
    var keyboardSustain: Bool {
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Settings.keyboardSustainKey)
        }
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyboardSustainKey)
        }
    }
    
    var phonemeboardSustain: Bool {
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Settings.phonemeboardSustainKey)
        }
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.phonemeboardSustainKey)
        }
    }
    
    init() {
        NSUserDefaults.standardUserDefaults().registerDefaults([
            Settings.keyboardSustainKey: false,
            Settings.phonemeboardSustainKey: false
            ])
    }

}
