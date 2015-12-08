//
//  Synthesizer.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

class Synthesizer: AKInstrument {
    
    var notes = [SynthesizerNote]()
    
    var vibratoDepth = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var vibratoFrequency = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 20.0)
    
    var output = AKAudio.globalParameter()
    
    override init() {
        super.init()
        
        addProperty(vibratoDepth)
        addProperty(vibratoFrequency)
        
        let note = SynthesizerNote()
        
        let envelope = AKLinearADSREnvelope(
            attackDuration: 0.01.ak,
            decayDuration: 0.01.ak,
            sustainLevel: 1.0.ak,
            releaseDuration: 0.01.ak,
            delay: AKConstant(value: 0.0)
        )
        
        let vibrato = AKLowFrequencyOscillator(
            waveformType: AKLowFrequencyOscillator.waveformTypeForSine(),
            frequency: vibratoFrequency,
            amplitude: vibratoDepth * (pow(2.0, 1.0 / 12.0) - 1.0).ak
        )
        
        let oscillator = AKVCOscillator(
            waveformType: AKVCOscillator.waveformTypeForSquare(),
            bandwidth: 0.5.ak,
            pulseWidth: 0.5.ak,
            frequency: note.frequency * (vibrato + 1.0.ak),
            amplitude: note.amplitude * envelope
        )
        
        assignOutput(output, to: oscillator)
    }
    
}
