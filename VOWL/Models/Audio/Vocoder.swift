//
//  Vocoder.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Vocoder: AKInstrument {
    
    var output = AKAudio.globalParameter()
    
    init(withInput input: AKAudio) {
        super.init()
        
        let filter = AKResonantFilter(
            input: input,
            centerFrequency: AKConstant(value: 2000.0),
            bandwidth: AKConstant(value: 1000.0)
        )

        assignOutput(output, to: filter)
        
        resetParameter(input)
    }

}
