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
    
    static let keyboardSustain = Setting<Bool>(key: "keyboardSustain", defaultValue: false)
    static let phonemeboardSustain = Setting<Bool>(key: "phonemeboardSustain", defaultValue: false)
    
    static let formantsBandwidth = Setting<Float>(key: "formantsBandwidth", defaultValue: 1.0)
    static let formantsFrequency = Setting<Float>(key: "formantsFrequency", defaultValue: 1.0)
    
    static let bitcrushMix = Setting<Float>(key: "bitcrushMix", defaultValue: 0.0)
    static let bitcrushDepth = Setting<Float>(key: "bitcrushDepth", defaultValue: 8.0)
    static let bitcrushRate = Setting<Float>(key: "bitcrushRate", defaultValue: 4000.0)
    
    static let reverbMix = Setting<Float>(key: "reverbMix", defaultValue: 0.0)
    static let reverbFeedback = Setting<Float>(key: "reverbFeedback", defaultValue: 0.0)
    static let reverbCutoff = Setting<Float>(key: "reverbCutoff", defaultValue: 200.0)
    
    static let vibratoWaveform = Setting<Float>(key: "vibratoWaveform", defaultValue: AKLowFrequencyOscillator.waveformTypeForSine().value)
    static let vibratoDepth = Setting<Float>(key: "vibratoDepth", defaultValue: 0.0)
    static let vibratoFrequency = Setting<Float>(key: "vibratoFrequency", defaultValue: 0.0)
    
    static let tremoloWaveform = Setting<Float>(key: "tremoloWaveform", defaultValue: AKLowFrequencyOscillator.waveformTypeForSine().value)
    static let tremoloDepth = Setting<Float>(key: "tremoloDepth", defaultValue: 0.0)
    static let tremoloFrequency = Setting<Float>(key: "tremoloFrequency", defaultValue: 0.0)
    
    static let envelopeAttack = Setting<Float>(key: "envelopeAttack", defaultValue: 0.002)
    static let envelopeDecay = Setting<Float>(key: "envelopeDecay", defaultValue: 0.002)
    static let envelopeSustain = Setting<Float>(key: "envelopeSustain", defaultValue: 1.0)
    static let envelopeRelease = Setting<Float>(key: "envelopeRelease", defaultValue: 0.002)
    
    static let keyboardLeftInterval = Setting<Int>(key: "keyboardLeftInterval", defaultValue: 4)
    static let keyboardRightInterval = Setting<Int>(key: "keyboardRightInterval", defaultValue: 7)

}
