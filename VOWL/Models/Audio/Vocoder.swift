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
    
    var bandwidth1 = AKInstrumentProperty()
    var bandwidth2 = AKInstrumentProperty()
    var bandwidth3 = AKInstrumentProperty()
    
    var amplitude = AKInstrumentProperty(minimum: 0.0, maximum: 1.0)
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
        super.init()
        
        addProperty(frequency1)
        addProperty(frequency2)
        addProperty(frequency3)
        
        addProperty(bandwidth1)
        addProperty(bandwidth2)
        addProperty(bandwidth3)
        
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
        
        let balance = AKBalance(
            input: filter3,
            comparatorAudioSource: input.scaledBy(amplitude)
        )

        assignOutput(output, to: balance)
        
        resetParameter(input)
    }

}
