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
    
    @IBOutlet weak var bitcrushMixControl: AudioControl? {
        didSet {
            bitcrushMixControl?.onChangeValue = { value in
                Audio.master.bitcrushMix.value = value
                Settings.bitcrushMix.value = value
            }
            bitcrushMixControl?.value = Settings.bitcrushMix.value
        }
    }
    
    @IBOutlet weak var bitcrushDepthControl: AudioControl? {
        didSet {
            bitcrushDepthControl?.onChangeValue = { value in
                Audio.master.bitcrushDepth.value = value
                Settings.bitcrushDepth.value = value
            }
            bitcrushDepthControl?.value = Settings.bitcrushDepth.value
        }
    }
    
    @IBOutlet weak var bitcrushRateControl: AudioControl? {
        didSet {
            bitcrushRateControl?.onChangeValue = { value in
                Audio.master.bitcrushRate.value = value
                Settings.bitcrushRate.value = value
            }
            bitcrushRateControl?.value = Settings.bitcrushRate.value
        }
    }
    
    @IBOutlet weak var reverbMixControl: AudioControl? {
        didSet {
            reverbMixControl?.onChangeValue = { value in
                Audio.master.reverbMix.value = value
                Settings.reverbMix.value = value
            }
            reverbMixControl?.value = Settings.reverbMix.value
        }
    }
    
    @IBOutlet weak var reverbFeedbackControl: AudioControl? {
        didSet {
            reverbFeedbackControl?.onChangeValue = { value in
                Audio.master.reverbFeedback.value = value
                Settings.reverbFeedback.value = value
            }
            reverbFeedbackControl?.value = Settings.reverbFeedback.value
        }
    }
    
    @IBOutlet weak var reverbCutoffControl: AudioControl? {
        didSet {
            reverbCutoffControl?.onChangeValue = { value in
                Audio.master.reverbCutoff.value = value
                Settings.reverbCutoff.value = value
            }
            reverbCutoffControl?.value = Settings.reverbCutoff.value
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        formantsBandwidthControl?.value = Settings.formantsBandwidth.defaultValue
        formantsFrequencyControl?.value = Settings.formantsFrequency.defaultValue
        
        bitcrushMixControl?.value = Settings.bitcrushMix.defaultValue
        bitcrushDepthControl?.value = Settings.bitcrushDepth.defaultValue
        bitcrushRateControl?.value = Settings.bitcrushRate.defaultValue
        
        reverbMixControl?.value = Settings.reverbMix.defaultValue
        reverbFeedbackControl?.value = Settings.reverbFeedback.defaultValue
        reverbCutoffControl?.value = Settings.reverbCutoff.defaultValue
    }
    
}
