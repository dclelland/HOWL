//
//  SynthesizerViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import ProtonomeAudioKitControls

class SynthesizerViewController: UIViewController {
    
    @IBOutlet weak var vibratoDepthDialControl: DialControl? {
        didSet {
            vibratoDepthDialControl?.value = Settings.vibratoDepth.value
            vibratoDepthDialControl?.onChangeValue = { value in
                Audio.synthesizer.vibratoDepth.value = value
                Settings.vibratoDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var vibratoFrequencyDialControl: DialControl? {
        didSet {
            vibratoFrequencyDialControl?.value = Settings.vibratoFrequency.value
            vibratoFrequencyDialControl?.onChangeValue = { value in
                Audio.synthesizer.vibratoFrequency.value = value
                Settings.vibratoFrequency.value = value
            }
        }
    }
    
    @IBOutlet weak var keyboardLeftIntervalDialControl: DialControl? {
        didSet {
            keyboardLeftIntervalDialControl?.value = Float(Settings.keyboardLeftInterval.value)
            keyboardLeftIntervalDialControl?.onChangeValue = { value in
                self.keyboardViewController?.keyboard.leftInterval = Int(value)
                self.keyboardViewController?.refreshNotes()
                self.keyboardViewController?.refreshView()
                Settings.keyboardLeftInterval.value = Int(value)
            }
            keyboardLeftIntervalDialControl?.onTouchDown = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardLeftIntervalDialControl?.onTouchUp = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
        }
    }
    
    @IBOutlet weak var keyboardRightIntervalDialControl: DialControl? {
        didSet {
            keyboardRightIntervalDialControl?.value = Float(Settings.keyboardRightInterval.value)
            keyboardLeftIntervalDialControl?.onChangeValue = { value in
                self.keyboardViewController?.keyboard.rightInterval = Int(value)
                self.keyboardViewController?.refreshNotes()
                self.keyboardViewController?.refreshView()
                Settings.keyboardRightInterval.value = Int(value)
            }
            keyboardLeftIntervalDialControl?.onTouchDown = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardLeftIntervalDialControl?.onTouchUp = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        vibratoDepthDialControl?.value = Settings.vibratoDepth.defaultValue
        vibratoFrequencyDialControl?.value = Settings.vibratoFrequency.defaultValue
        keyboardLeftIntervalDialControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
        keyboardRightIntervalDialControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
    }
    
    // MARK: - Private getters
    
    private var keyboardViewController: KeyboardViewController? {
        if let flipViewController = flipViewController {
            return flipViewController.howlViewController?.keyboardViewController
        } else {
            return howlViewController?.keyboardViewController
        }
    }
    
    private var keyboardViewControllerMode: KeyboardViewController.Mode {
        if keyboardLeftIntervalDialControl?.selected == true || keyboardRightIntervalDialControl?.selected == true {
            return .ShowBackground
        }
        
        return .Normal
    }
    
}
