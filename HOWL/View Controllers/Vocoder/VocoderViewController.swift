//
//  VocoderViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import ProtonomeAudioKitControls

class VocoderViewController: UIViewController {
    
    @IBOutlet weak var formantsBandwidthControl: AudioControl? {
        didSet {
            formantsBandwidthControl?.onChangeValue = { value in
                Audio.sopranoVocoder.bandwidth.value = value
                Audio.altoVocoder.bandwidth.value = value
                Audio.tenorVocoder.bandwidth.value = value
                Audio.bassVocoder.bandwidth.value = value
                Settings.formantsBandwidth.value = value
            }
            formantsBandwidthControl?.value = Settings.formantsBandwidth.value
        }
    }
    
    @IBOutlet weak var formantsFrequencyControl: AudioControl? {
        didSet {
            formantsFrequencyControl?.onChangeValue = { value in
                Audio.sopranoVocoder.frequency.value = value
                Audio.altoVocoder.frequency.value = value
                Audio.tenorVocoder.frequency.value = value
                Audio.bassVocoder.frequency.value = value
                Settings.formantsFrequency.value = value
            }
            formantsFrequencyControl?.value = Settings.formantsFrequency.value
        }
    }
    
    @IBOutlet weak var effectsBitcrushControl: AudioControl? {
        didSet {
            effectsBitcrushControl?.onChangeValue = { value in
                Audio.master.bitcrushMix.value = value
                Settings.effectsBitcrush.value = value
            }
            effectsBitcrushControl?.value = Settings.effectsBitcrush.value
        }
    }
    
    @IBOutlet weak var effectsReverbControl: AudioControl? {
        didSet {
            effectsReverbControl?.onChangeValue = { value in
                Audio.master.reverbMix.value = value
                Settings.effectsReverb.value = value
            }
            effectsReverbControl?.value = Settings.effectsReverb.value
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        formantsBandwidthControl?.value = Settings.formantsBandwidth.defaultValue
        formantsFrequencyControl?.value = Settings.formantsFrequency.defaultValue
        effectsBitcrushControl?.value = Settings.effectsBitcrush.defaultValue
        effectsReverbControl?.value = Settings.effectsReverb.defaultValue
    }
    
}
