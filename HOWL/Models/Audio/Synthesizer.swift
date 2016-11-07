//
//  Synthesizer.swift
//  HOWL
//
//  Created by Daniel Clelland on 3/07/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit
import Persistable

class Synthesizer: AKNode {
    
    // MARK: - Properties
    
    var vibratoWaveform = Persistent(value: 0.0, key: "synthesizerVibratoWaveform")
    var vibratoDepth = Persistent(value: 0.0, key: "synthesizerVibratoDepth")
    var vibratoRate = Persistent(value: 0.0, key: "synthesizerVibratoRate")
    
    var tremoloWaveform = Persistent(value: 0.0, key: "synthesizerTremoloWaveform")
    var tremoloDepth = Persistent(value: 0.0, key: "synthesizerTremoloDepth")
    var tremoloRate = Persistent(value: 0.0, key: "synthesizerTremoloRate")
    
    var envelopeAttack = Persistent(value: 0.002, key: "synthesizerEnvelopeAttack")
    var envelopeDecay = Persistent(value: 0.002, key: "synthesizerEnvelopeDecay")
    var envelopeSustain = Persistent(value: 1.0, key: "synthesizerEnvelopeSustain")
    var envelopeRelease = Persistent(value: 0.002, key: "synthesizerEnvelopeRelease")
    
    // MARK: - Nodes
    
    // MARK: - Initialization
    
    override init() {
        let oscillator = AKOscillator(waveform: AKTable(.sawtooth, size: 2048))
        oscillator.amplitude = 1.0
        oscillator.frequency = 60.0
        
        super.init()
        
        self.avAudioNode = oscillator.avAudioNode
    }
    
    // MARK: - Note creation
    
    func note(with frequency: Float) -> SynthesizerNote {
        return SynthesizerNote()
    }
    
    // MARK: - Note actions
    
    func play(_ note: SynthesizerNote) {
        
    }
    
    func stop(_ note: SynthesizerNote) {
        
    }
    
}
