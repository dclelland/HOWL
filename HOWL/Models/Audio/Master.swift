//
//  Master.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

class Master: AKInstrument {
    
    var amplitude = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    
    var effectsBitcrush = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var effectsReverb = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    
    init(withInput input: AKAudio) {
        super.init()
        
        addProperty(amplitude)
        
        addProperty(effectsBitcrush)
        addProperty(effectsReverb)
        
        let balance = AKBalance(
            input: input,
            comparatorAudioSource: input * amplitude * 0.25.ak
        )
        
        let bitcrush = AKDecimator(
            input: balance,
            bitDepth: 24.ak,
            sampleRate: 4000.ak
        )
        
        let bitcrushOutput = AKMix(
            input1: balance,
            input2: bitcrush,
            balance: effectsBitcrush
        )
        
        let reverb = AKReverb(
            input: bitcrushOutput,
            feedback: 0.75.ak,
            cutoffFrequency: 16000.ak
        )
        
        let reverbLeftOutput = AKMix(
            input1: bitcrushOutput,
            input2: reverb.leftOutput,
            balance: effectsReverb
        )
        
        let reverbRightOutput = AKMix(
            input1: bitcrushOutput,
            input2: reverb.rightOutput,
            balance: effectsReverb
        )
        
        let leftClipper = AKClipper(
            input: reverbLeftOutput,
            limit: 1.0.ak,
            method: AKClipper.clippingMethodBramDeJong(),
            clippingStartPoint: 0.9375.ak
        )
        
        let rightClipper = AKClipper(
            input: reverbRightOutput,
            limit: 1.0.ak,
            method: AKClipper.clippingMethodBramDeJong(),
            clippingStartPoint: 0.9375.ak
        )
        
        let output = AKStereoAudio(
            leftAudio: leftClipper,
            rightAudio: rightClipper
        )
        
        setStereoAudioOutput(output)
        
        resetParameter(input)
    }
    
    // MARK: - Actions
    
    func mute() {
        amplitude.value = 0.0
    }
    
    func unmute() {
        amplitude.value = 1.0
    }
    
}
