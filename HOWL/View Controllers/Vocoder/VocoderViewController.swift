//
//  VocoderViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class VocoderViewController: UIViewController {
    
    @IBOutlet weak var formantsBandwidthDialControl: DialControl?
    @IBOutlet weak var formantsFrequencyDialControl: DialControl?
    
    @IBOutlet weak var effectsBitcrushDialControl: DialControl?
    @IBOutlet weak var effectsReverbDialControl: DialControl?
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: ToolbarButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: ToolbarButton) {
        formantsBandwidthDialControl?.value = 100.0
        formantsFrequencyDialControl?.value = 100.0
        effectsBitcrushDialControl?.value = 0.0
        effectsReverbDialControl?.value = 0.0
    }
    
    // MARK: - Dial control events
    
    @IBAction func formantsBandwidthDialControlValueChanged(dialControl: DialControl) {
        Audio.shared.sopranoVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.shared.altoVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.shared.tenorVocoder.bandwidth.value = dialControl.value / 100.0
        Audio.shared.bassVocoder.bandwidth.value = dialControl.value / 100.0
    }
    
    @IBAction func formantsFrequencyDialControlValueChanged(dialControl: DialControl) {
        Audio.shared.sopranoVocoder.frequency.value = dialControl.value / 100.0
        Audio.shared.altoVocoder.frequency.value = dialControl.value / 100.0
        Audio.shared.tenorVocoder.frequency.value = dialControl.value / 100.0
        Audio.shared.bassVocoder.frequency.value = dialControl.value / 100.0
    }
    
    @IBAction func effectsBitcrushDialControlValueChanged(dialControl: DialControl) {
        Audio.shared.master.bitcrushMix.value = dialControl.value / 100.0
    }
    
    @IBAction func effectsReverbDialControlValueChanged(dialControl: DialControl) {
        Audio.shared.master.reverbMix.value = dialControl.value / 100.0
    }
    
}
