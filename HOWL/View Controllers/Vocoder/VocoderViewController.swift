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
    
    @IBOutlet weak var flipButton: UIButton?
    
    @IBOutlet weak var resetButton: UIButton?
    
    @IBOutlet weak var formantsFrequencyControl: AudioControl? {
        didSet {
            formantsFrequencyControl?.value = Audio.client!.vocoder.formantsFrequency.value
            formantsFrequencyControl?.onChangeValue = { value in
                Audio.client?.vocoder.formantsFrequency.value = value
            }
        }
    }
    
    @IBOutlet weak var formantsBandwidthControl: AudioControl? {
        didSet {
            formantsBandwidthControl?.value = Audio.client!.vocoder.formantsBandwidth.value
            formantsBandwidthControl?.onChangeValue = { value in
                Audio.client?.vocoder.formantsBandwidth.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsBitcrushControl: AudioControl? {
        didSet {
            effectsBitcrushControl?.value = Audio.client!.master.effectsBitcrush.value
            effectsBitcrushControl?.onChangeValue = { value in
                Audio.client?.master.effectsBitcrush.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsReverbControl: AudioControl? {
        didSet {
            effectsReverbControl?.value = Audio.client!.master.effectsReverb.value
            effectsReverbControl?.onChangeValue = { value in
                Audio.client?.master.effectsReverb.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXShapeControl: AudioControl? {
        didSet {
            lfoXShapeControl?.value = Audio.client!.vocoder.lfoXShape.value
            lfoXShapeControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXShape.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXDepthControl: AudioControl? {
        didSet {
            lfoXDepthControl?.value = Audio.client!.vocoder.lfoXDepth.value
            lfoXDepthControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXRateControl: AudioControl? {
        didSet {
            lfoXRateControl?.value = Audio.client!.vocoder.lfoXRate.value
            lfoXRateControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXRate.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYShapeControl: AudioControl? {
        didSet {
            lfoYShapeControl?.value = Audio.client!.vocoder.lfoYShape.value
            lfoYShapeControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYShape.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYDepthControl: AudioControl? {
        didSet {
            lfoYDepthControl?.value = Audio.client!.vocoder.lfoYDepth.value
            lfoYDepthControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYRateControl: AudioControl? {
        didSet {
            lfoYRateControl?.value = Audio.client!.vocoder.lfoYRate.value
            lfoYRateControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYRate.value = value
            }
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        formantsFrequencyControl?.value = Audio.client!.vocoder.formantsFrequency.defaultValue
        formantsBandwidthControl?.value = Audio.client!.vocoder.formantsBandwidth.defaultValue
        
        effectsBitcrushControl?.value = Audio.client!.master.effectsBitcrush.defaultValue
        effectsReverbControl?.value = Audio.client!.master.effectsReverb.defaultValue
        
        lfoXShapeControl?.value = Audio.client!.vocoder.lfoXShape.defaultValue
        lfoXDepthControl?.value = Audio.client!.vocoder.lfoXDepth.defaultValue
        lfoXRateControl?.value = Audio.client!.vocoder.lfoXRate.defaultValue
        
        lfoYShapeControl?.value = Audio.client!.vocoder.lfoYShape.defaultValue
        lfoYDepthControl?.value = Audio.client!.vocoder.lfoYDepth.defaultValue
        lfoYRateControl?.value = Audio.client!.vocoder.lfoYRate.defaultValue
    }
    
}
