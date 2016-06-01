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
    
    var vibratoWaveform = AKInstrumentProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value)
    var vibratoDepth = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var vibratoRate = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 20.0)
    
    var tremoloWaveform = AKInstrumentProperty(value: AKLowFrequencyOscillator.waveformTypeForSine().value)
    var tremoloDepth = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    var tremoloRate = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 20.0)
    
    var envelopeAttack = AKInstrumentProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    var envelopeDecay = AKInstrumentProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    var envelopeSustain = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 1.0)
    var envelopeRelease = AKInstrumentProperty(value: 0.002, minimum: 0.002, maximum: 2.0)
    
    var microphoneAmplitude = AKInstrumentProperty(value: 0.0, minimum: 0.0, maximum: 1.0)
    
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
        
        addProperty(microphoneAmplitude)
        
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
        
        let input = AKAudioInput()
        
        assignOutput(output, to: oscillator + input)
    }
    
    // MARK: - Note creation
    
    func note(withFrequency frequency: Float) -> SynthesizerNote {
        return SynthesizerNote(
            frequency: frequency,
            vibratoWaveform: vibratoWaveform.value,
            tremoloWaveform: tremoloWaveform.value,
            envelopeAttack: envelopeAttack.value,
            envelopeDecay: envelopeDecay.value,
            envelopeSustain: envelopeSustain.value,
            envelopeRelease: envelopeRelease.value
        )
    }
    
    // MARK: Actions
    
    func muteMicrophone() {
        microphoneAmplitude.value = 0.0
    }
    
    func unmuteMicrophone() {
        microphoneAmplitude.value = 1.0
    }
    
}
