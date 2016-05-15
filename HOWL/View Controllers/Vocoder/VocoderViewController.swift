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
    
    @IBOutlet weak var formantsBandwidthDialControl: DialControl? {
        didSet {
            formantsBandwidthDialControl?.value = Settings.formantsBandwidth.value
            formantsBandwidthDialControl?.onChangeValue = { value in
                Audio.sopranoVocoder.bandwidth.value = value
                Audio.altoVocoder.bandwidth.value = value
                Audio.tenorVocoder.bandwidth.value = value
                Audio.bassVocoder.bandwidth.value = value
                Settings.formantsBandwidth.value = value
            }
        }
    }
    
    @IBOutlet weak var formantsFrequencyDialControl: DialControl? {
        didSet {
            formantsFrequencyDialControl?.value = Settings.formantsFrequency.value
            formantsFrequencyDialControl?.onChangeValue = { value in
                Audio.sopranoVocoder.frequency.value = value
                Audio.altoVocoder.frequency.value = value
                Audio.tenorVocoder.frequency.value = value
                Audio.bassVocoder.frequency.value = value
                Settings.formantsFrequency.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsBitcrushDialControl: DialControl? {
        didSet {
            effectsBitcrushDialControl?.value = Settings.effectsBitcrush.value
            effectsBitcrushDialControl?.onChangeValue = { value in
                Audio.master.bitcrushMix.value = value
                Settings.effectsBitcrush.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsReverbDialControl: DialControl? {
        didSet {
            effectsReverbDialControl?.value = Settings.effectsReverb.value
            effectsReverbDialControl?.onChangeValue = { value in
                Audio.master.reverbMix.value = value
                Settings.effectsReverb.value = value
            }
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        formantsBandwidthDialControl?.value = Settings.formantsBandwidth.defaultValue
        formantsFrequencyDialControl?.value = Settings.formantsFrequency.defaultValue
        effectsBitcrushDialControl?.value = Settings.effectsBitcrush.defaultValue
        effectsReverbDialControl?.value = Settings.effectsReverb.defaultValue
    }
    
}
