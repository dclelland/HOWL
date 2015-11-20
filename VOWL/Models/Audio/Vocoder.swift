//
//  Vocoder.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Vocoder: AKInstrument {
    
    var frequency1 = AKInstrumentProperty(minimum: 0.0, maximum: 22050.0)
    var frequency2 = AKInstrumentProperty(minimum: 0.0, maximum: 22050.0)
    
    var amplitude = AKInstrumentProperty(minimum: 0.0, maximum: 1.0)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
        super.init()
        
        addProperty(frequency1)
        addProperty(frequency2)
        addProperty(amplitude)
        
        let filter1 = AKResonantFilter(
            input: input,
            centerFrequency: frequency1,
            bandwidth: frequency1.scaledBy(AKConstant(value: 0.25))
        )
        
        let filter2 = AKResonantFilter(
            input: filter1,
            centerFrequency: frequency2,
            bandwidth: frequency2.scaledBy(AKConstant(value: 0.25))
        )
        
        let balance = AKBalance(
            input: filter2,
            comparatorAudioSource: input.scaledBy(amplitude)
        )

        assignOutput(output, to: balance)
        
        resetParameter(input)
    }
    
    // MARK: - Actions
    
    func startWithFrequencies(frequencies: (Float, Float)) {
        (self.frequency1.value, self.frequency2.value) = frequencies
        
        self.amplitude.value = 1.0
    }
    
    func updateWithFrequencies(frequencies: (Float, Float)) {
        (self.frequency1.value, self.frequency2.value) = frequencies
    }
    
    func stopWithFrequencies(frequencies: (Float, Float)) {
        (self.frequency1.value, self.frequency2.value) = frequencies
        
        self.amplitude.value = 0.0
    }

}
