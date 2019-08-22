//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit
import Lerp
import ProtonomeAudioKitControls

class Vocoder: AKInstrument {
    
    struct Voice {
        
        struct Phoneme {
            
            let f1: Float
            let f2: Float
            let f3: Float
            let f4: Float
            
            var formants: [Float] {
                return [f1, f2, f3, f4]
            }
            
            func mixed(with phoneme: Phoneme, ratio: Float) -> Phoneme {
                return Phoneme(
                    f1: ratio.lerp(min: f1, max: phoneme.f1),
                    f2: ratio.lerp(min: f2, max: phoneme.f2),
                    f3: ratio.lerp(min: f3, max: phoneme.f3),
                    f4: ratio.lerp(min: f4, max: phoneme.f4)
                )
            }
            
        }
        
        let æ: Phoneme // top left
        let α: Phoneme // top right
        let i: Phoneme // bottom left
        let u: Phoneme // bottom right
        
        func mixed(with voice: Voice, ratio: Float) -> Voice {
            return Voice(
                æ: æ.mixed(with: voice.æ, ratio: ratio),
                α: α.mixed(with: voice.α, ratio: ratio),
                i: i.mixed(with: voice.i, ratio: ratio),
                u: u.mixed(with: voice.u, ratio: ratio)
            )
        }
        
        static let male = Voice(
            æ: Voice.Phoneme(f1: 844, f2: 1656, f3: 2437, f4: 3704),
            α: Voice.Phoneme(f1: 768, f2: 1333, f3: 2522, f4: 3687),
            i: Voice.Phoneme(f1: 324, f2: 2985, f3: 3329, f4: 3807),
            u: Voice.Phoneme(f1: 378, f2: 997, f3: 2343, f4: 3357)
        )
        
        static let female = Voice(
            æ: Voice.Phoneme(f1: 967, f2: 1999, f3: 2760, f4: 4306),
            α: Voice.Phoneme(f1: 936, f2: 1551, f3: 2815, f4: 4299),
            i: Voice.Phoneme(f1: 426, f2: 3589, f3: 3691, f4: 4471),
            u: Voice.Phoneme(f1: 459, f2: 1105, f3: 2735, f4: 4115)
        )
        
        static let child = Voice(
            æ: Voice.Phoneme(f1: 818, f2: 1743, f3: 3005, f4: 4232),
            α: Voice.Phoneme(f1: 597, f2: 1137, f3: 2987, f4: 4167),
            i: Voice.Phoneme(f1: 431, f2: 3949, f3: 4059, f4: 4720),
            u: Voice.Phoneme(f1: 494, f2: 1345, f3: 2988, f4: 4276)
        )
        
    }
    
    let voice = Voice.male
    
    var amplitude = AKInstrumentProperty(value: 0.0)
    var inputAmplitude = AKInstrumentProperty(value: 0.0)
    
    var xIn = Property(value: 0.5, key: "vocoderXIn")
    var yIn = Property(value: 0.5, key: "vocoderYIn")
    
    var xOut = AKInstrumentProperty(value: 0.5)
    var yOut = AKInstrumentProperty(value: 0.5)
    
    var lfoXShape = Property(value: 0.25, key: "vocoderLfoXShape")
    var lfoXDepth = Property(value: 0.0, key: "vocoderLfoXDepth")
    var lfoXRate = Property(value: 0.0, key: "vocoderLfoXRate")
    
    var lfoYShape = Property(value: 0.25, key: "vocoderLfoYShape")
    var lfoYDepth = Property(value: 0.0, key: "vocoderLfoYDepth")
    var lfoYRate = Property(value: 0.0, key: "vocoderLfoYRate")
    
    var formantsFrequency = Property(value: 1.0, key: "vocoderFormantsFrequency")
    var formantsBandwidth = Property(value: 1.0, key: "vocoderFormantsBandwidth")
    
    var output = AKAudio.global()
    
    init(input: AKAudio) {
        super.init()
        
        addProperty(amplitude)
        
        addProperty(xIn)
        addProperty(yIn)
        
        addProperty(xOut)
        addProperty(yOut)
        
        addProperty(lfoXShape)
        addProperty(lfoXDepth)
        addProperty(lfoXRate)
        
        addProperty(lfoYShape)
        addProperty(lfoYDepth)
        addProperty(lfoYRate)
        
        addProperty(formantsFrequency)
        addProperty(formantsBandwidth)
        
        let lfoX = AKLowFrequencyOscillator(
            waveformType: AKLowFrequencyOscillator.waveformTypeForSine(),
            frequency: lfoXRate,
            amplitude: lfoXShape
        )
        
        let lfoXDistortion = tanh(lfoX) * (sinh(lfoXShape * 2.0.ak) / (1.0.ak - cosh(lfoXShape * 2.0.ak)))
        
        let lfoXPost = lfoXDistortion * lfoXDepth * 0.5.ak
        
        let lfoY = AKLowFrequencyOscillator(
            waveformType: AKLowFrequencyOscillator.waveformTypeForSine(),
            frequency: lfoYRate,
            amplitude: lfoYShape
        )
        
        let lfoYDistortion = tanh(lfoY) * (sinh(lfoYShape * 2.0.ak) / (1.0.ak - cosh(lfoYShape * 2.0.ak)))
        
        let lfoYPost = lfoYDistortion * lfoYDepth * 0.5.ak
        
        connect(AKAssignment(output: xOut, input: lfoXPost + xIn))
        connect(AKAssignment(output: yOut, input: lfoYPost + yIn))
        
        let topFrequencies = zip(voice.æ.formants, voice.α.formants).map { topLeftFrequency, topRightFrequency -> AKParameter in
            return xOut * (topRightFrequency - topLeftFrequency).ak + topLeftFrequency.ak
        }
        
        let bottomFrequencies = zip(voice.i.formants, voice.u.formants).map { bottomLeftFrequency, bottomRightFrequency -> AKParameter in
            return xOut * (bottomRightFrequency - bottomLeftFrequency).ak + bottomLeftFrequency.ak
        }
        
        let frequencyScale = AKMaximum(firstInput: formantsFrequency, secondInput: 0.01.ak)
        
        let frequencies = zip(topFrequencies, bottomFrequencies).map { topFrequency, bottomFrequency -> AKParameter in
            return (yOut * (bottomFrequency - topFrequency) + topFrequency) * frequencyScale
        }
        
        let bandwidthScale = AKMaximum(firstInput: formantsBandwidth, secondInput: 0.01.ak)
        
        let bandwidths = frequencies.map { frequency in
            return (frequency * 0.02.ak + 50.0.ak) * bandwidthScale
        }
        
        let mutedAudioInput = AKAudioInput() * AKPortamento(input: inputAmplitude, halfTime: 0.001.ak)
        
        let mutedInput = (input + mutedAudioInput) * AKPortamento(input: amplitude, halfTime: 0.001.ak)
        
        let filter = zip(frequencies, bandwidths).reduce(mutedInput) { input, parameters -> AKResonantFilter in
            let (frequency, bandwidth) = parameters
            return AKResonantFilter(
                input: input,
                centerFrequency: AKPortamento(input: frequency, halfTime: 0.001.ak),
                bandwidth: AKPortamento(input: bandwidth, halfTime: 0.001.ak)
            )
        }
        
        let balance = AKBalance(
            input: filter,
            comparatorAudioSource: mutedInput
        )
        
        let clipper = AKClipper(
            input: balance * 0.25.ak,
            limit: 1.0.ak,
            method: AKClipper.clippingMethodBramDeJong(),
            clippingStartPoint: 0.9375.ak
        )
        
        assignOutput(output, to: clipper)
        
        resetParameter(input)
    }
    
    // MARK: - Actions
    
    var enabled: Bool {
        set {
            amplitude.value = newValue ? 1.0 : 0.0
        }
        get {
            return amplitude.value != 0.0
        }
    }
    
    var inputEnabled: Bool {
        set {
            inputAmplitude.value = newValue ? 1.0 : 0.0
        }
        get {
            return inputAmplitude.value != 0.0
        }
    }
    
    // MARK: - Properties
    
    var location: CGPoint {
        set {
            xIn.value = Float(newValue.x)
            yIn.value = Float(newValue.y)
        }
        get {
            return CGPoint(
                x: CGFloat(xOut.value),
                y: CGFloat(yOut.value)
            )
        }
    }
    
}
