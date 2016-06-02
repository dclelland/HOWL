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
    var amplitude = AKNoteProperty()
    
    var vibratoWaveform = AKNoteProperty()
    var tremoloWaveform = AKNoteProperty()
    
    var envelopeAttack = AKNoteProperty()
    var envelopeDecay = AKNoteProperty()
    var envelopeSustain = AKNoteProperty()
    var envelopeRelease = AKNoteProperty()
    
    override init() {
        super.init()
        addProperty(self.frequency)
        addProperty(self.amplitude)
        
        addProperty(self.vibratoWaveform)
        addProperty(self.tremoloWaveform)
        
        addProperty(self.envelopeAttack)
        addProperty(self.envelopeDecay)
        addProperty(self.envelopeSustain)
        addProperty(self.envelopeRelease)
    }
    
    convenience init(frequency: Float,
                     amplitude: Float,
                     vibratoWaveform: Float,
                     tremoloWaveform: Float,
                     envelopeAttack: Float,
                     envelopeDecay: Float,
                     envelopeSustain: Float,
                     envelopeRelease: Float) {
        self.init()
        self.frequency.value = frequency
        self.amplitude.value = amplitude
        
        self.vibratoWaveform.value = vibratoWaveform
        self.tremoloWaveform.value = tremoloWaveform

        self.envelopeAttack.value = envelopeAttack
        self.envelopeDecay.value = envelopeDecay
        self.envelopeSustain.value = envelopeSustain
        self.envelopeRelease.value = envelopeRelease
    }
    
}
