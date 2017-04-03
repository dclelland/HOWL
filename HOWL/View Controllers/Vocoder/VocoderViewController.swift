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
    
    @IBOutlet weak var formantsFrequencyControl: AudioControl!
    @IBOutlet weak var formantsBandwidthControl: AudioControl!
    
    @IBOutlet weak var effectsBitcrushControl: AudioControl!
    @IBOutlet weak var effectsReverbControl: AudioControl!
    
    @IBOutlet weak var lfoXShapeControl: AudioControl!
    @IBOutlet weak var lfoXDepthControl: AudioControl!
    @IBOutlet weak var lfoXRateControl: AudioControl!
    
    @IBOutlet weak var lfoYShapeControl: AudioControl!
    @IBOutlet weak var lfoYDepthControl: AudioControl!
    @IBOutlet weak var lfoYRateControl: AudioControl!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (control, property) in controls {
            control.value = property.value
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(_ button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(_ button: UIButton) {
        for (control, property) in controls {
            control.value = property.defaultValue
        }
    }
    
    // MARK: - Controls
    
    fileprivate var controls: [AudioControl: Property] {
        guard let client = Audio.client else {
            return [:]
        }
        
        return [
            formantsFrequencyControl: client.vocoder.formantsFrequency,
            formantsBandwidthControl: client.vocoder.formantsBandwidth,
            effectsBitcrushControl: client.master.effectsBitcrush,
            effectsReverbControl: client.master.effectsReverb,
            lfoXShapeControl: client.vocoder.lfoXShape,
            lfoXDepthControl: client.vocoder.lfoXDepth,
            lfoXRateControl: client.vocoder.lfoXRate,
            lfoYShapeControl: client.vocoder.lfoYShape,
            lfoYDepthControl: client.vocoder.lfoYDepth,
            lfoYRateControl: client.vocoder.lfoYRate
        ]
    }
    
}

// MARK: Audio control delegate

extension VocoderViewController: AudioControlDelegate {
    
    func audioControl(_ audioControl: AudioControl, valueChanged value: Float) {
        controls[audioControl]?.value = value
    }
    
}
