//
//  Vocoder.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Vocoder: AKInstrument {
    
    var frequency1 = AKInstrumentProperty()
    var frequency2 = AKInstrumentProperty()
    var frequency3 = AKInstrumentProperty()
    var frequency4 = AKInstrumentProperty()
    var frequency5 = AKInstrumentProperty()
    
    var bandwidth1 = AKInstrumentProperty()
    var bandwidth2 = AKInstrumentProperty()
    var bandwidth3 = AKInstrumentProperty()
    var bandwidth4 = AKInstrumentProperty()
    var bandwidth5 = AKInstrumentProperty()
    
    var amplitude = AKInstrumentProperty(minimum: 0.0, maximum: 1.0)
    
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
        
        let filter1 = AKResonantFilter(
            input: input,
            centerFrequency: frequency1,
            bandwidth: bandwidth1
        )
        
        let filter2 = AKResonantFilter(
            input: filter1,
            centerFrequency: frequency2,
            bandwidth: bandwidth2
        )
        
        let filter3 = AKResonantFilter(
            input: filter2,
            centerFrequency: frequency3,
            bandwidth: bandwidth3
        )
        
        let filter4 = AKResonantFilter(
            input: filter3,
            centerFrequency: frequency4,
            bandwidth: bandwidth4
        )
        
        let filter5 = AKResonantFilter(
            input: filter4,
            centerFrequency: frequency5,
            bandwidth: bandwidth5
        )
        
        let balance = AKBalance(
            input: filter5,
            comparatorAudioSource: input.scaledBy(amplitude)
        )

        assignOutput(output, to: balance)
        
        resetParameter(input)
    }

}
