//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Vocoder: AKInstrument {
    
    let topLeftFrequencies: [Float] = [588, 1952, 2601, 3624] // /α/
    let topRightFrequencies: [Float] = [768, 1333, 2522, 3687] // /æ/
    let bottomLeftFrequencies: [Float] = [342, 2322, 3000, 3657] // /i/
    let bottomRightFrequencies: [Float] = [378, 997, 2343, 3357] // /u/
    
    var x = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var y = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    var formantsFrequency = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var formantsBandwidth = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
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
    
}
