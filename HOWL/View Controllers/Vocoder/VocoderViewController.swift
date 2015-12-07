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
        if let flipViewController = self.flipViewController {
            flipViewController.flip()
        }
    }
    
    @IBAction func resetButtonTapped(button: ToolbarButton) {
        formantsBandwidthDialControl?.value = 100.0
        formantsFrequencyDialControl?.value = 100.0
        effectsBitcrushDialControl?.value = 0.0
        effectsReverbDialControl?.value = 0.0
    }
    
    // MARK: - Dial control events
    
    @IBAction func dialControlValueChanged(dialControl: DialControl) {
        
    }
    
}
