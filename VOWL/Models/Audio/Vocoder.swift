//
//  Vocoder.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Vocoder: AKInstrument {
    
    var frequency1 = AKInstrumentProperty(value: 500.0)
    var frequency2 = AKInstrumentProperty(value: 1000.0)
    var frequency3 = AKInstrumentProperty(value: 1500.0)
    var frequency4 = AKInstrumentProperty(value: 2000.0)
    var frequency5 = AKInstrumentProperty(value: 2500.0)
    
    var bandwidth1 = AKInstrumentProperty(value: 100.0)
    var bandwidth2 = AKInstrumentProperty(value: 100.0)
    var bandwidth3 = AKInstrumentProperty(value: 100.0)
    var bandwidth4 = AKInstrumentProperty(value: 100.0)
    var bandwidth5 = AKInstrumentProperty(value: 100.0)
    
    var amplitude = AKInstrumentProperty(minimum: 0.0, maximum: 1.0)
    var portamento = AKInstrumentProperty(value: 0.02, minimum: 0.0, maximum: 0.02)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
        super.init()
        
        addProperty(frequency1)
        addProperty(frequency2)
        addProperty(frequency3)
        addProperty(frequency4)
        addProperty(frequency5)
        
        addProperty(bandwidth1)
        addProperty(bandwidth2)
        addProperty(bandwidth3)
        addProperty(bandwidth4)
        addProperty(bandwidth5)
        
        addProperty(amplitude)
        addProperty(portamento)
        
        let filter1 = AKResonantFilter(
            input: input,
            centerFrequency: AKPortamento(input: frequency1, halfTime: portamento),
            bandwidth: AKPortamento(input: bandwidth1, halfTime: portamento)
        )
        
        let filter2 = AKResonantFilter(
            input: filter1,
            centerFrequency: AKPortamento(input: frequency2, halfTime: portamento),
            bandwidth: AKPortamento(input: bandwidth2, halfTime: portamento)
        )
        
        let filter3 = AKResonantFilter(
            input: filter2,
            centerFrequency: AKPortamento(input: frequency3, halfTime: portamento),
            bandwidth: AKPortamento(input: bandwidth3, halfTime: portamento)
        )
        
        let filter4 = AKResonantFilter(
            input: filter3,
            centerFrequency: AKPortamento(input: frequency4, halfTime: portamento),
            bandwidth: AKPortamento(input: bandwidth4, halfTime: portamento)
        )
        
        let filter5 = AKResonantFilter(
            input: filter4,
            centerFrequency: AKPortamento(input: frequency5, halfTime: portamento),
            bandwidth: AKPortamento(input: bandwidth5, halfTime: portamento)
        )
        
        let balance = AKBalance(
            input: filter5,
            comparatorAudioSource: input.scaledBy(amplitude)
        )

        assignOutput(output, to: balance)
    }
    
    // MARK: - Actions
    
    func mute() {
        self.amplitude.value = 0.0
    }
    
    func unmute() {
        self.amplitude.value = 1.0
    }
    
    func updateWithPhoneme(phoneme: Phoneme) {
        let (frequency1, frequency2, frequency3, frequency4, frequency5) = phoneme.frequencies
        let (bandwidth1, bandwidth2, bandwidth3, bandwidth4, bandwidth5) = phoneme.bandwidths
        
        self.frequency1.value = frequency1
        self.frequency2.value = frequency2
        self.frequency3.value = frequency3
        self.frequency4.value = frequency4
        self.frequency5.value = frequency5
        
        self.bandwidth1.value = bandwidth1
        self.bandwidth2.value = bandwidth2
        self.bandwidth3.value = bandwidth3
        self.bandwidth4.value = bandwidth4
        self.bandwidth5.value = bandwidth5
    }
    
}
