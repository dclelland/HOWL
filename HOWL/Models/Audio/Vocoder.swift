//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Vocoder: AKInstrument {
    
    var topLeftFormants: Quartet<Float>
    var topRightFormants: Quartet<Float>
    var bottomLeftFormants: Quartet<Float>
    var bottomRightFormants: Quartet<Float>
    
    var frequencies: Quartet<AKInstrumentProperty> = [
        AKInstrumentProperty(value: 500.0),
        AKInstrumentProperty(value: 1000.0),
        AKInstrumentProperty(value: 1500.0),
        AKInstrumentProperty(value: 2000.0)
    ]
    
    var bandwidths: Quartet<AKInstrumentProperty> = [
        AKInstrumentProperty(value: 100.0),
        AKInstrumentProperty(value: 100.0),
        AKInstrumentProperty(value: 100.0),
        AKInstrumentProperty(value: 100.0)
    ]
    
    var x = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    var y = AKInstrumentProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
    
    var frequency = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var bandwidth = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio, topLeftFormants: Quartet<Float>, topRightFormants: Quartet<Float>, bottomLeftFormants: Quartet<Float>, bottomRightFormants: Quartet<Float>) {
        
        self.topLeftFormants = topLeftFormants
        self.topRightFormants = topRightFormants
        self.bottomLeftFormants = bottomLeftFormants
        self.bottomRightFormants = bottomRightFormants
        
        super.init()
        
        addProperty(x)
        addProperty(y)
        
        addProperty(frequency)
        addProperty(bandwidth)
        
        frequencies.forEach { addProperty($0) }
        bandwidths.forEach { addProperty($0) }
        
        let guardFrequency = AKMaximum(firstInput: frequency, secondInput: 0.01.ak)
        let guardBandwidth = AKMaximum(firstInput: bandwidth, secondInput: 0.01.ak)
        
        let filter1 = AKResonantFilter(
            input: input,
            centerFrequency: AKPortamento(input: frequencies[0] * guardFrequency, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[0] * guardBandwidth, halfTime: 0.02.ak)
        )
        
        let filter2 = AKResonantFilter(
            input: filter1,
            centerFrequency: AKPortamento(input: frequencies[1] * guardFrequency, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[1] * guardBandwidth, halfTime: 0.02.ak)
        )
        
        let filter3 = AKResonantFilter(
            input: filter2,
            centerFrequency: AKPortamento(input: frequencies[2] * guardFrequency, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[2] * guardBandwidth, halfTime: 0.02.ak)
        )
        
        let filter4 = AKResonantFilter(
            input: filter3,
            centerFrequency: AKPortamento(input: frequencies[3] * guardFrequency, halfTime: 0.02.ak),
            bandwidth: AKPortamento(input: bandwidths[3] * guardBandwidth, halfTime: 0.02.ak)
        )
        
        let balance = AKBalance(
            input: filter4,
            comparatorAudioSource: input
        )
        
        assignOutput(output, to: balance)
    }
    
    // MARK: Constructors
    
    enum Register: Float {
        case Bass = 0.87
        case Tenor = 0.94
        case Alto = 1.08
        case Soprano = 1.11
    }
    
    static func male(register: Register? = nil, withInput input: AKAudio) -> Vocoder {
        let register = register?.rawValue ?? 1.0
        return Vocoder(
            withInput: input,
            topLeftFormants: [768, 1333, 2522, 3687] * register,
            topRightFormants: [588, 1952, 2601, 3624] * register,
            bottomLeftFormants: [378, 997, 2343, 3357] * register,
            bottomRightFormants: [342, 2322, 3000, 3657] * register
        )
    }
    
    static func female(register: Register? = nil, withInput input: AKAudio) -> Vocoder {
        let register = register?.rawValue ?? 1.0
        return Vocoder(
            withInput: input,
            topLeftFormants: [936, 1551, 2815, 4299] * register,
            topRightFormants: [669, 2349, 2972, 4290] * register,
            bottomLeftFormants: [459, 1105, 2735, 4115] * register,
            bottomRightFormants: [437, 2761, 3372, 4352] * register
        )
    }
    
    static func child(register: Register? = nil, withInput input: AKAudio) -> Vocoder {
        let register = register?.rawValue ?? 1.0
        return Vocoder(
            withInput: input,
            topLeftFormants: [1002, 1688, 2950, 4307] * register,
            topRightFormants: [717, 2501, 3289, 4409] * register,
            bottomLeftFormants: [494, 1345, 2988, 4276] * register,
            bottomRightFormants: [452, 3081, 3702, 4572] * register
        )
    }
    
}
