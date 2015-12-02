//
//  SynthesizerNote.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

class SynthesizerNote: AKNote {
    
    var frequency = AKNoteProperty()
    var amplitude = AKNoteProperty(minimum: 0.0, maximum: 1.0)
    
    override init() {
        super.init()
        addProperty(self.frequency)
        addProperty(self.amplitude)
    }
    
    convenience init(withFrequency frequency: Float) {
        self.init(withFrequency: frequency, andAmplitude: 1.0)
    }
    
    convenience init(withFrequency frequency: Float, andAmplitude amplitude: Float) {
        self.init()
        self.frequency.value = frequency
        self.amplitude.value = amplitude
    }
    
}
