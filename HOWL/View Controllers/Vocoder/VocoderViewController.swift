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
    
    @IBOutlet weak var formantsFrequencyControl: AudioControl? {
        didSet {
            formantsFrequencyControl?.onChangeValue = { value in
                for vocoder in Audio.vocoders {
                    vocoder.formantsFrequency.value = value
                }
                Settings.formantsFrequency.value = value
            }
            formantsFrequencyControl?.value = Settings.formantsFrequency.value
        }
    }
    
    @IBOutlet weak var formantsBandwidthControl: AudioControl? {
        didSet {
            formantsBandwidthControl?.onChangeValue = { value in
                for vocoder in Audio.vocoders {
                    vocoder.formantsBandwidth.value = value
                }
                Settings.formantsBandwidth.value = value
            }
            formantsBandwidthControl?.value = Settings.formantsBandwidth.value
        }
    }
    
    @IBOutlet weak var lfoFrequencyControl: AudioControl? {
        didSet {
            lfoFrequencyControl?.onChangeValue = { value in
                Settings.lfoFrequency.value = value
            }
            lfoFrequencyControl?.value = Settings.lfoFrequency.value
        }
    }
    
    @IBOutlet weak var lfoXAmplitudeControl: AudioControl? {
        didSet {
            lfoXAmplitudeControl?.onChangeValue = { value in
                Settings.lfoXAmplitude.value = value
            }
            lfoXAmplitudeControl?.value = Settings.lfoXAmplitude.value
        }
    }
    
    @IBOutlet weak var lfoYAmplitudeControl: AudioControl? {
        didSet {
            lfoYAmplitudeControl?.onChangeValue = { value in
                Settings.lfoYAmplitude.value = value
            }
            lfoYAmplitudeControl?.value = Settings.lfoYAmplitude.value
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
        formantsFrequencyControl?.value = Settings.formantsFrequency.defaultValue
        formantsBandwidthControl?.value = Settings.formantsBandwidth.defaultValue
        
        lfoFrequencyControl?.value = Settings.lfoFrequency.defaultValue
        lfoXAmplitudeControl?.value = Settings.lfoXAmplitude.defaultValue
        lfoYAmplitudeControl?.value = Settings.lfoYAmplitude.defaultValue
        
        bitcrushMixControl?.value = Settings.bitcrushMix.defaultValue
        bitcrushDepthControl?.value = Settings.bitcrushDepth.defaultValue
        bitcrushRateControl?.value = Settings.bitcrushRate.defaultValue
        
        reverbMixControl?.value = Settings.reverbMix.defaultValue
        reverbFeedbackControl?.value = Settings.reverbFeedback.defaultValue
        reverbCutoffControl?.value = Settings.reverbCutoff.defaultValue
    }
    
}
