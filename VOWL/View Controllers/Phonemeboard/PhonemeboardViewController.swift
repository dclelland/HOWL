//
//  PhonemeboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class PhonemeboardViewController: UIViewController, MultitouchGestureRecognizerDelegate {
    
    @IBOutlet weak var phonemeboardView: PhonemeboardView?
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer?
    
    @IBOutlet weak var holdButton: HoldButton? {
        didSet {
            holdButton?.selected = Settings.shared.phonemeboardSustain
        }
    }
    
    let phonemeboard = Phonemeboard()
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: HoldButton) {
        Settings.shared.phonemeboardSustain = !Settings.shared.phonemeboardSustain
        button.selected = Settings.shared.phonemeboardSustain
        
        if !button.selected {
            self.multitouchGestureRecognizer?.endTouches()
        }
    }
    
    // MARK: - Multitouch gesture recognizer delegate
    
    func multitouchGestureRecognizerShouldSustainTouches(gestureRecognizer: MultitouchGestureRecognizer) -> Bool {
        return Settings.shared.phonemeboardSustain
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        print("begin")
        
        let frequency1 = Float(touch.locationInView(touch.view).x) * 10.0 + 200.0
        let frequency2 = Float(touch.locationInView(touch.view).y) * 10.0 + 200.0
        
        Audio.shared.vocoder.startWithFrequencies((frequency1, frequency2))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        print("move")
        
        let frequency1 = Float(touch.locationInView(touch.view).x) * 10.0 + 200.0
        let frequency2 = Float(touch.locationInView(touch.view).y) * 10.0 + 200.0
        
        Audio.shared.vocoder.updateWithFrequencies((frequency1, frequency2))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        print("cancel")
        
        let frequency1 = Float(touch.locationInView(touch.view).x) * 10.0 + 200.0
        let frequency2 = Float(touch.locationInView(touch.view).y) * 10.0 + 200.0
        
        Audio.shared.vocoder.stopWithFrequencies((frequency1, frequency2))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        print("end")
        
        let frequency1 = Float(touch.locationInView(touch.view).x) * 10.0 + 200.0
        let frequency2 = Float(touch.locationInView(touch.view).y) * 10.0 + 200.0
        
        Audio.shared.vocoder.stopWithFrequencies((frequency1, frequency2))
    }
    
}
