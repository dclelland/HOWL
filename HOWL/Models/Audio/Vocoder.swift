//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Vocoder: AKInstrument {
    
    let topLeftFrequencies: [Float] = [844, 1656, 2437, 3704] // /æ/
    let topRightFrequencies: [Float] = [768, 1333, 2522, 3687] // /α/
    let bottomLeftFrequencies: [Float] = [324, 2985, 3329, 3807] // /i/
    let bottomRightFrequencies: [Float] = [378, 997, 2343, 3357] // /u/
    
    var xIn = InstrumentProperty(value: 0.5, key: "vocoderXIn")
    var yIn = InstrumentProperty(value: 0.5, key: "vocoderYIn")
    
    var xOut = InstrumentProperty(value: 0.5)
    var yOut = InstrumentProperty(value: 0.5)
    
    var lfoXShape = InstrumentProperty(value: 0.0, key: "vocoderLfoXShape")
    var lfoXDepth = InstrumentProperty(value: 0.0, key: "vocoderLfoXDepth")
    var lfoXRate = InstrumentProperty(value: 0.0, key: "vocoderLfoXRate")
    
    var lfoYShape = InstrumentProperty(value: 0.0, key: "vocoderLfoYShape")
    var lfoYDepth = InstrumentProperty(value: 0.0, key: "vocoderLfoYDepth")
    var lfoYRate = InstrumentProperty(value: 0.0, key: "vocoderLfoYRate")
    
    var formantsFrequency = InstrumentProperty(value: 1.0, key: "vocoderFormantsFrequency")
    var formantsBandwidth = InstrumentProperty(value: 1.0, key: "vocoderFormantsBandwidth")
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
        super.init()
        
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
        
        let topFrequencies = zip(topLeftFrequencies, topRightFrequencies).map { topLeftFrequency, topRightFrequency in
            return xOut * (topRightFrequency - topLeftFrequency).ak + topLeftFrequency.ak
        }
        
        let bottomFrequencies = zip(bottomLeftFrequencies, bottomRightFrequencies).map { bottomLeftFrequency, bottomRightFrequency in
            return xOut * (bottomRightFrequency - bottomLeftFrequency).ak + bottomLeftFrequency.ak
        }
        
        let frequencyScale = AKMaximum(firstInput: formantsFrequency, secondInput: 0.01.ak)
        
        let frequencies = zip(topFrequencies, bottomFrequencies).map { topFrequency, bottomFrequency in
            return (yOut * (bottomFrequency - topFrequency) + topFrequency) * frequencyScale
        }
        
        let bandwidthScale = AKMaximum(firstInput: formantsBandwidth, secondInput: 0.01.ak)
        
        let bandwidths = frequencies.map { frequency in
            return (frequency * 0.02.ak + 50.0.ak) * bandwidthScale
        }
        
        let filter = zip(frequencies, bandwidths).reduce(input) { input, parameters in
            let (frequency, bandwidth) = parameters
            return AKResonantFilter(
                input: input,
                centerFrequency: AKPortamento(input: frequency, halfTime: 0.001.ak),
                bandwidth: AKPortamento(input: bandwidth, halfTime: 0.001.ak)
            )
        }
        
        let balance = AKBalance(
            input: filter,
            comparatorAudioSource: input
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
    
}

extension Vocoder {
    
    var location: CGPoint {
        set {
            xIn.value = Float(newValue.x)
            yIn.value = Float(newValue.y)
        }
        get {
            let x = CGFloat(xOut.value)
            let y = CGFloat(yOut.value)
            return CGPoint(x: x, y: y)
        }
    }

}
