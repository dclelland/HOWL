//
//  VocoderViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class VocoderViewController: UIViewController {
    
    @IBOutlet weak var formantsBandwidthDialControl: DialControl? {
        didSet { formantsBandwidthDialControl?.value = Settings.formantsBandwidth.value }
    }
    
    @IBOutlet weak var formantsFrequencyDialControl: DialControl? {
        didSet { formantsFrequencyDialControl?.value = Settings.formantsFrequency.value }
    }
    
    @IBOutlet weak var effectsBitcrushDialControl: DialControl? {
        didSet { effectsBitcrushDialControl?.value = Settings.effectsBitcrush.value }
    }
    
    @IBOutlet weak var effectsReverbDialControl: DialControl? {
        didSet { effectsReverbDialControl?.value = Settings.effectsReverb.value }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: ToolbarButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: ToolbarButton) {
        formantsBandwidthDialControl?.value = Settings.formantsBandwidth.defaultValue
        formantsFrequencyDialControl?.value = Settings.formantsFrequency.defaultValue
        effectsBitcrushDialControl?.value = Settings.effectsBitcrush.defaultValue
        effectsReverbDialControl?.value = Settings.effectsReverb.defaultValue
    }
    
    // MARK: - Dial control events
    
    @IBAction func formantsBandwidthDialControlValueChanged(dialControl: DialControl) {
        Settings.formantsBandwidth.value = dialControl.value
        
        Audio.sopranoVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.altoVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.tenorVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.bassVocoder.bandwidth.value = dialControl.value / 100.0
    }
    
    @IBAction func formantsFrequencyDialControlValueChanged(dialControl: DialControl) {
        Settings.formantsFrequency.value = dialControl.value
        
        Audio.sopranoVocoder.frequency.value = dialControl.value / 100.0
        Audio.altoVocoder.frequency.value = dialControl.value / 100.0
        Audio.tenorVocoder.frequency.value = dialControl.value / 100.0
        Audio.bassVocoder.frequency.value = dialControl.value / 100.0
    }
    
    @IBAction func effectsBitcrushDialControlValueChanged(dialControl: DialControl) {
        Settings.effectsBitcrush.value = dialControl.value
        
        Audio.master.bitcrushMix.value = dialControl.value / 100.0
    }
    
    @IBAction func effectsReverbDialControlValueChanged(dialControl: DialControl) {
        Settings.effectsReverb.value = dialControl.value
        
        Audio.master.reverbMix.value = dialControl.value / 100.0
    }
    
}
