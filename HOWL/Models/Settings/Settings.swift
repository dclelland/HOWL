//
//  Settings.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import AudioKit

struct Settings {
    
    static let phonemeboardSustain = Setting<Bool>(key: "phonemeboardSustain", defaultValue: false)
    static let keyboardSustain = Setting<Bool>(key: "keyboardSustain", defaultValue: false)
    
    static let keyboardLeftInterval = Setting<Int>(key: "keyboardLeftInterval", defaultValue: 4)
    static let keyboardRightInterval = Setting<Int>(key: "keyboardRightInterval", defaultValue: 7)

}
