//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Vocoder: AKInstrument {
    
    let topLeftFrequencies: [Float] = [588, 1952, 2601, 3624] // /æ/
    let topRightFrequencies: [Float] = [768, 1333, 2522, 3687] // /α/
    let bottomLeftFrequencies: [Float] = [342, 2322, 3000, 3657] // /i/
    let bottomRightFrequencies: [Float] = [378, 997, 2343, 3357] // /u/
    
    var xIn = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var yIn = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    var xOut = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var yOut = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    var lfoXShape = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var lfoXDepth = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var lfoXRate = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 20.0)
    
    var lfoYShape = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var lfoYDepth = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var lfoYRate = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 20.0)
    
    var formantsFrequency = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var formantsBandwidth = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    
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
            amplitude: lfoXDepth * 0.5.ak
        )
        
        let lfoY = AKLowFrequencyOscillator(
            waveformType: AKLowFrequencyOscillator.waveformTypeForSine(),
            frequency: lfoYRate,
            amplitude: lfoYDepth * 0.5.ak
        )
        
        connect(AKAssignment(output: xOut, input: lfoX + xIn))
        connect(AKAssignment(output: yOut, input: lfoY + yIn))
        
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
        
        assignOutput(output, to: balance)
        
        resetParameter(input)
    }
    
}
