//
//  Master.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Master: AKInstrument {
    
    var bitcrushMix = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var reverbMix = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    init(withInput input: AKAudio, voices: (AKAudio, AKAudio, AKAudio, AKAudio)) {
        super.init()
        
        addProperty(bitcrushMix)
        addProperty(reverbMix)
        
        let (soprano, alto, tenor, bass) = voices
        
        let quartet = (soprano + alto + tenor + bass) * 0.05.ak
        
        let bitcrush = AKDecimator(
            input: quartet,
            bitDepth: 20.ak,
            sampleRate: 1200.ak
        )
        
        let bitcrushOutput = AKMix(
            input1: quartet,
            input2: bitcrush,
            balance: bitcrushMix
        )
        
        let reverb = AKReverb(
            input: bitcrushOutput,
            feedback: 0.5.ak,
            cutoffFrequency: 16000.ak
        )
        
        let reverbLeftOutput = AKMix(
            input1: bitcrushOutput,
            input2: reverb.leftOutput,
            balance: reverbMix
        )
        
        let reverbRightOutput = AKMix(
            input1: bitcrushOutput,
            input2: reverb.rightOutput,
            balance: reverbMix
        )
        
        let output = AKStereoAudio(leftAudio: reverbLeftOutput, rightAudio: reverbRightOutput)
        
        setStereoAudioOutput(output)
        
        resetParameter(input)
        
        resetParameter(soprano)
        resetParameter(alto)
        resetParameter(tenor)
        resetParameter(bass)
    }
    
}
