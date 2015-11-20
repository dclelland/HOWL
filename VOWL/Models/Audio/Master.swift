//
//  Master.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Master: AKInstrument {
    
    init(withInput input: AKAudio) {
        super.init()
        
        let reverb = AKReverb(
            input: input,
            feedback: AKConstant(value: 0.5),
            cutoffFrequency: AKConstant(value: 16000.0)
        )
        
        setStereoAudioOutput(reverb)
        
        resetParameter(input)
    }
    
}
