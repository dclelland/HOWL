//
//  Settings.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

struct Settings {
    
    static let keyboardSustain = Setting<Bool>(key: "keyboardSustain", defaultValue: false)
    static let phonemeboardSustain = Setting<Bool>(key: "phonemeboardSustain", defaultValue: false)
    
    static let formantsBandwidth = Setting<Float>(key: "formantsBandwidth", defaultValue: 1.0)
    static let formantsFrequency = Setting<Float>(key: "formantsFrequency", defaultValue: 1.0)
    
    static let effectsBitcrush = Setting<Float>(key: "effectsBitcrush", defaultValue: 0.0)
    static let effectsReverb = Setting<Float>(key: "effectsReverb", defaultValue: 0.0)
    
    static let vibratoDepth = Setting<Float>(key: "vibratoDepth", defaultValue: 0.0)
    static let vibratoFrequency = Setting<Float>(key: "vibratoFrequency", defaultValue: 0.0)
    
    static let keyboardLeftInterval = Setting<Int>(key: "keyboardLeftInterval", defaultValue: 4)
    static let keyboardRightInterval = Setting<Int>(key: "keyboardRightInterval", defaultValue: 7)

}
