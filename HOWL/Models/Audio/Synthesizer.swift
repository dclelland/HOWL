//
//  Synthesizer.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

class Synthesizer: AKInstrument {
    
    var notes = [SynthesizerNote]()
    
    var vibratoWaveform = InstrumentProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value, key: "synthesizerVibratoWaveform")
    var vibratoDepth = InstrumentProperty(value: 0.0, key: "synthesizerVibratoDepth")
    var vibratoRate = InstrumentProperty(value: 0.0, key: "synthesizerVibratoRate")
    
    var tremoloWaveform = InstrumentProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value, key: "synthesizerTremoloWaveform")
    var tremoloDepth = InstrumentProperty(value: 0.0, key: "synthesizerTremoloDepth")
    var tremoloRate = InstrumentProperty(value: 0.0, key: "synthesizerTremoloRate")
    
    var envelopeAttack = InstrumentProperty(value: 0.002, key: "synthesizerEnvelopeAttack")
    var envelopeDecay = InstrumentProperty(value: 0.002, key: "synthesizerEnvelopeDecay")
    var envelopeSustain = InstrumentProperty(value: 1.0, key: "synthesizerEnvelopeSustain")
    var envelopeRelease = InstrumentProperty(value: 0.002, key: "synthesizerEnvelopeRelease")
    
    var output = AKAudio.globalParameter()
    
    override init() {
        super.init()
        
        addProperty(vibratoWaveform)
        addProperty(vibratoDepth)
        addProperty(vibratoRate)
        
        addProperty(tremoloWaveform)
        addProperty(tremoloDepth)
        addProperty(tremoloRate)
        
        addProperty(envelopeAttack)
        addProperty(envelopeDecay)
        addProperty(envelopeSustain)
        addProperty(envelopeRelease)
        
        let note = SynthesizerNote()
        
        let envelope = AKLinearADSREnvelope(
            attackDuration: note.envelopeAttack,
            decayDuration: note.envelopeDecay,
            sustainLevel: note.envelopeSustain,
            releaseDuration: note.envelopeRelease,
            delay: 0.0.ak
        )
        
        let vibrato = AKLowFrequencyOscillator(
            waveformType: note.vibratoWaveform,
            frequency: vibratoRate,
            amplitude: vibratoDepth * (pow(2.0, 1.0 / 12.0) - 1.0).ak
        )
        
        let tremolo = AKLowFrequencyOscillator(
            waveformType: note.tremoloWaveform,
            frequency: tremoloRate,
            amplitude: tremoloDepth * 0.5.ak
        )
        
        let oscillator = AKVCOscillator(
            waveformType: AKVCOscillator.waveformTypeForSawtooth(),
            bandwidth: 0.5.ak,
            pulseWidth: 0.5.ak,
            frequency: note.frequency * (vibrato + 1.0.ak),
            amplitude: note.amplitude * envelope * (tremolo - ((tremoloDepth * 0.5.ak) - 1.0.ak))
        )
        
        assignOutput(output, to: oscillator)
    }
    
    // MARK: - Note creation
    
    func note(withFrequency frequency: Float) -> SynthesizerNote {
        return SynthesizerNote(
            frequency: frequency,
            amplitude: 1.0,
            vibratoWaveform: vibratoWaveform.value,
            tremoloWaveform: tremoloWaveform.value,
            envelopeAttack: envelopeAttack.value,
            envelopeDecay: envelopeDecay.value,
            envelopeSustain: envelopeSustain.value,
            envelopeRelease: envelopeRelease.value
        )
    }
    
}
