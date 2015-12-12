//
//  SynthesizerViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class SynthesizerViewController: UIViewController {
    
    @IBOutlet weak var vibratoDepthDialControl: DialControl? {
        didSet { vibratoDepthDialControl?.value = Settings.vibratoDepth.value }
    }
    
    @IBOutlet weak var vibratoFrequencyDialControl: DialControl? {
        didSet { vibratoFrequencyDialControl?.value = Settings.vibratoFrequency.value }
    }
    
    @IBOutlet weak var keyboardLeftIntervalDialControl: DialControl? {
        didSet { keyboardLeftIntervalDialControl?.value = Float(Settings.keyboardLeftInterval.value) }
    }
    
    @IBOutlet weak var keyboardRightIntervalDialControl: DialControl? {
        didSet { keyboardRightIntervalDialControl?.value = Float(Settings.keyboardRightInterval.value) }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: ToolbarButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: ToolbarButton) {
        vibratoDepthDialControl?.value = Settings.vibratoDepth.defaultValue
        vibratoFrequencyDialControl?.value = Settings.vibratoFrequency.defaultValue
        keyboardLeftIntervalDialControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
        keyboardRightIntervalDialControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
    }
    
    // MARK: - Dial control events
    
    @IBAction func vibratoDepthDialControlValueChanged(dialControl: DialControl) {
        Settings.vibratoDepth.value = dialControl.value
        
        Audio.shared.synthesizer.vibratoDepth.value = dialControl.value / 100
    }
    
    @IBAction func vibratoFrequencyDialControlValueChanged(dialControl: DialControl) {
        Settings.vibratoFrequency.value = dialControl.value
        
        Audio.shared.synthesizer.vibratoFrequency.value = dialControl.value
    }
    
    @IBAction func keyboardLeftIntervalDialControlValueChanged(dialControl: DialControl) {
        Settings.keyboardLeftInterval.value = Int(dialControl.value)
        
        keyboardViewController?.keyboard.leftInterval = Int(dialControl.value)
        keyboardViewController?.keyboardView?.reloadData()
    }
    
    @IBAction func keyboardRightIntervalDialControlValueChanged(dialControl: DialControl) {
        Settings.keyboardRightInterval.value = Int(dialControl.value)
        
        keyboardViewController?.keyboard.rightInterval = Int(dialControl.value)
        keyboardViewController?.keyboardView?.reloadData()
    }
    
    // MARK: - Private getters
    
    var keyboardViewController: KeyboardViewController? {
        return flipViewController?.frontViewController as? KeyboardViewController
    }
    
}
