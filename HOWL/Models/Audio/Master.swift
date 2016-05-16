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
    
    var bitcrushMix = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var bitcrushDepth = AKInstrumentProperty(value: 8.0, minimum: 8.0, maximum: 24.0)
    var bitcrushRate = AKInstrumentProperty(value: 8000.0, minimum: 8000.0, maximum: 24000.0)
    
    var reverbMix = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var reverbFeedback = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var reverbCutoff = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 16000.0)
    
    init(withInput input: AKAudio, voices: [AKAudio]) {
        super.init()
        
        addProperty(amplitude)
        
        addProperty(bitcrushMix)
        addProperty(bitcrushDepth)
        addProperty(bitcrushRate)
        
        addProperty(reverbMix)
        addProperty(reverbMix)
        addProperty(reverbMix)
        
        let sum = AKSum()
        
        sum.inputs = voices
        
        let preBitcrush = AKBalance(
            input: sum,
            comparatorAudioSource: input * amplitude * 0.125.ak
        )
        
        let bitcrush = AKDecimator(
            input: preBitcrush,
            bitDepth: bitcrushDepth,
            sampleRate: bitcrushRate
        )
        
        let postBitcrush = AKBalance(
            input: bitcrush,
            comparatorAudioSource:preBitcrush
        )
        
        let bitcrushOutput = AKMix(
            input1: preBitcrush,
            input2: postBitcrush,
            balance: bitcrushMix
        )
        
        let reverb = AKReverb(
            input: bitcrushOutput,
            feedback: reverbFeedback,
            cutoffFrequency: reverbCutoff
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
        
        connect(sum)
        
        setStereoAudioOutput(output)
        
        resetParameter(input)
        
        voices.forEach { self.resetParameter($0) }
    }
    
    // MARK: - Actions
    
    func mute() {
        amplitude.value = 0.0
    }
    
    func unmute() {
        amplitude.value = 1.0
    }
    
}
