//
//  Synthesizer.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Synthesizer: AKInstrument {
    
    var output = AKAudio.globalParameter()
    
    override init() {
        super.init()
        
        let note = SynthesizerNote()
        
        let envelope = AKLinearADSREnvelope(
            attackDuration: AKConstant(value: 0.01),
            decayDuration: AKConstant(value: 0.01),
            sustainLevel: AKConstant(value: 1.0),
            releaseDuration: AKConstant(value: 0.01),
            delay: AKConstant(value: 0.0)
        )
        
        let oscillator = AKVCOscillator(
            waveformType: AKVCOscillator.waveformTypeForSquare(),
            bandwidth: AKConstant(value: 0.5),
            pulseWidth: AKConstant(value: 0.5),
            frequency: note.frequency,
            amplitude: note.amplitude.scaledBy(envelope)
        )
        
        assignOutput(output, to: oscillator)
    }

}
