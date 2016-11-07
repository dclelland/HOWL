//
//  Master.swift
//  HOWL
//
//  Created by Daniel Clelland on 3/07/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit
import Persistable

class Master: AKNode {
    
    // MARK: - Properties
    
    var effectsBitcrush = Persistent(value: 0.0, key: "masterEffectsBitcrush") {
        didSet {
            bitcrushMix.balance = effectsBitcrush.value
        }
    }
    
    var effectsReverb = Persistent(value: 0.0, key: "masterEffectsReverb") {
        didSet {
            reverbMix.balance = effectsReverb.value
        }
    }
    
    // MARK: - Nodes
    
    private let bitcrush: AKBitCrusher
    private let bitcrushMix: AKDryWetMixer
    
    private let reverb: AKCostelloReverb
    private let reverbMix: AKDryWetMixer
    
    // MARK: - Initialization
    
    init(withInput input: AKNode) {
        self.bitcrush = AKBitCrusher(input, bitDepth: 24.0, sampleRate: 4000.0)
        self.bitcrushMix = AKDryWetMixer(input, self.bitcrush, balance: self.effectsBitcrush.value)
        
        self.reverb = AKCostelloReverb(self.bitcrushMix, feedback: 0.75, cutoffFrequency: 16000.0)
        self.reverbMix = AKDryWetMixer(self.bitcrushMix, self.reverb, balance: self.effectsReverb.value)
        
        super.init()
        
        self.avAudioNode = self.reverbMix.avAudioNode
        input.addConnectionPoint(self)
    }
    
}
