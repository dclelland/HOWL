//
//  Master.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Master: AKInstrument {
    
    init(withInput input: AKAudio, voices: (AKAudio, AKAudio, AKAudio, AKAudio)) {
        super.init()
        
        let (soprano, alto, tenor, bass) = voices
        
        let quartet = soprano + alto + tenor + bass
        
        let reverb = AKReverb(
            input: quartet,
            feedback: 0.125.ak,
            cutoffFrequency: 16000.0.ak
        )
        
        let leftOutput = reverb.leftOutput * 0.125.ak + quartet * 0.25.ak
        let rightOutput = reverb.rightOutput * 0.125.ak + quartet * 0.25.ak
        
        let output = AKStereoAudio(leftAudio: leftOutput, rightAudio: rightOutput)
        
        setStereoAudioOutput(output.scaledBy(0.125.ak))
        
        resetParameter(input)
        
        resetParameter(soprano)
        resetParameter(alto)
        resetParameter(tenor)
        resetParameter(bass)
    }
    
}
