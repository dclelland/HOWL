//
//  Synthesizer.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Synthesizer: AKInstrument {
    
    var notes = [SynthesizerNote]()
    
    var output = AKAudio.globalParameter()
    
    override init() {
        super.init()
        
        let note = SynthesizerNote()
        
        let envelope = AKLinearADSREnvelope(
            attackDuration: 0.01.ak,
            decayDuration: 0.01.ak,
            sustainLevel: 1.0.ak,
            releaseDuration: 0.01.ak,
            delay: AKConstant(value: 0.0)
        )
        
        let oscillator = AKVCOscillator(
            waveformType: AKVCOscillator.waveformTypeForSquare(),
            bandwidth: 0.5.ak,
            pulseWidth: 0.5.ak,
            frequency: note.frequency,
            amplitude: note.amplitude * envelope
        )
        
        assignOutput(output, to: oscillator)
    }
    
}
