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
    
    var vibratoWaveform = AKNoteProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value)
    var tremoloWaveform = AKNoteProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value)
    
    var envelopeAttack = AKNoteProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    var envelopeDecay = AKNoteProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    var envelopeSustain = AKNoteProperty(value: 1.0, minimum: 0.0, maximum: 1.0)
    var envelopeRelease = AKNoteProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    
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
                     amplitude: Float = 1.0,
                     vibratoWaveform: Float = AKLowFrequencyOscillator.waveformTypeForSine().value,
                     tremoloWaveform: Float = AKLowFrequencyOscillator.waveformTypeForSine().value,
                     envelopeAttack: Float = 0.002,
                     envelopeDecay: Float = 0.002,
                     envelopeSustain: Float = 1.0,
                     envelopeRelease: Float = 0.002) {
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
