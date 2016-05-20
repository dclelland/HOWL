//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Vocoder: AKInstrument {
    
    var topLeftFrequencies: Quartet<Float>
    var topRightFrequencies: Quartet<Float>
    var bottomLeftFrequencies: Quartet<Float>
    var bottomRightFrequencies: Quartet<Float>
    
    var x = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var y = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    var formantsFrequency = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var formantsBandwidth = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio, topLeftFrequencies: Quartet<Float>, topRightFrequencies: Quartet<Float>, bottomLeftFrequencies: Quartet<Float>, bottomRightFrequencies: Quartet<Float>) {
        
        self.topLeftFrequencies = topLeftFrequencies
        self.topRightFrequencies = topRightFrequencies
        self.bottomLeftFrequencies = bottomLeftFrequencies
        self.bottomRightFrequencies = bottomRightFrequencies
        
        super.init()
        
        addProperty(x)
        addProperty(y)
        
        addProperty(formantsFrequency)
        addProperty(formantsBandwidth)
        
        let topFrequencies = zip(topLeftFrequencies, topRightFrequencies).map { topLeftFrequency, topRightFrequency in
            return x * (topRightFrequency - topLeftFrequency).ak + topLeftFrequency.ak
        }
        
        let bottomFrequencies = zip(bottomLeftFrequencies, bottomRightFrequencies).map { bottomLeftFrequency, bottomRightFrequency in
            return x * (bottomRightFrequency - bottomLeftFrequency).ak + bottomLeftFrequency.ak
        }
        
        let frequencies = zip(topFrequencies, bottomFrequencies).map { topFrequency, bottomFrequency in
            return y * (bottomFrequency - topFrequency) + topFrequency
        }
        
        let bandwidths = frequencies.map { frequency in
            return frequency * 0.02.ak + 50.0.ak
        }
        
        let frequencyMultiplier = AKMaximum(firstInput: formantsFrequency, secondInput: 0.01.ak)
        
        let bandwidthMultiplier = AKMaximum(firstInput: formantsBandwidth, secondInput: 0.01.ak)
        
        let filter1 = AKResonantFilter(
            input: input,
            centerFrequency: AKPortamento(input: frequencies[0] * frequencyMultiplier, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[0] * bandwidthMultiplier, halfTime: 0.02.ak)
        )
        
        let filter2 = AKResonantFilter(
            input: filter1,
            centerFrequency: AKPortamento(input: frequencies[1] * frequencyMultiplier, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[1] * bandwidthMultiplier, halfTime: 0.02.ak)
        )
        
        let filter3 = AKResonantFilter(
            input: filter2,
            centerFrequency: AKPortamento(input: frequencies[2] * frequencyMultiplier, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[2] * bandwidthMultiplier, halfTime: 0.02.ak)
        )
        
        let filter4 = AKResonantFilter(
            input: filter3,
            centerFrequency: AKPortamento(input: frequencies[3] * frequencyMultiplier, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[3] * bandwidthMultiplier, halfTime: 0.02.ak)
        )
        
        let balance = AKBalance(
            input: filter4,
            comparatorAudioSource: input
        )
        
        assignOutput(output, to: balance)
        
        self.resetParameter(input)
    }
    
    // MARK: Constructors
    
    static func male(withInput input: AKAudio) -> Vocoder {
        return Vocoder(
            withInput: input,
            topLeftFrequencies: [768, 1333, 2522, 3687],
            topRightFrequencies: [588, 1952, 2601, 3624],
            bottomLeftFrequencies: [378, 997, 2343, 3357],
            bottomRightFrequencies: [342, 2322, 3000, 3657]
        )
    }
    
    static func female(withInput input: AKAudio) -> Vocoder {
        return Vocoder(
            withInput: input,
            topLeftFrequencies: [936, 1551, 2815, 4299],
            topRightFrequencies: [669, 2349, 2972, 4290],
            bottomLeftFrequencies: [459, 1105, 2735, 4115],
            bottomRightFrequencies: [437, 2761, 3372, 4352]
        )
    }
    
    static func child(withInput input: AKAudio) -> Vocoder {
        return Vocoder(
            withInput: input,
            topLeftFrequencies: [1002, 1688, 2950, 4307],
            topRightFrequencies: [717, 2501, 3289, 4409],
            bottomLeftFrequencies: [494, 1345, 2988, 4276],
            bottomRightFrequencies: [452, 3081, 3702, 4572]
        )
    }
    
}
