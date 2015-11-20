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
        Audio.shared.vocoder.startWithFrequencies(self.frequenciesForTouch(touch))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        Audio.shared.vocoder.updateWithFrequencies(self.frequenciesForTouch(touch))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        Audio.shared.vocoder.stopWithFrequencies(self.frequenciesForTouch(touch))
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        Audio.shared.vocoder.stopWithFrequencies(self.frequenciesForTouch(touch))
    }
    
    // MARK: - Frequencies
    
//    //Gauges the speed of the mouse using differentials.
//    logspeed = 1 + 0.1 * log(abs(Xval-pXval) + abs(Yval-pYval) + 1);
//    
//    //Sets the fundamental at 280Hz as well as increasing it as a factor of the logarithm
//    //of the cursor's speed. This introduces some nice vibrato into the frequencies, as
//    //well as allowing variation in all three frequencies without requiring a third control
//    //axis.
//    fundamental = 280 * logspeed;
//    
//    //Sets the first formant as a function of the exponential of the X axis.
//    formant1 = 170000 / max(1, (Yval + 125)) * logspeed;
//    
//    //Sets the second formant as a function of the angle from a point below the canvas (so
//    //that values near the top of the canvas are expanded - vowels 'a', 'o', and 'e' are
//    //much more sensitive to variations in the second formant).
//    formant2 = -4000/PI * atan2(Yval - 700, Xval - 250) - 400 * logspeed;
    
    private func frequenciesForTouch(touch: UITouch) -> (Float, Float) {
        guard let phonemeboardView = self.phonemeboardView else {
            return (0.0, 0.0)
        }
        
        let x = touch.locationInView(phonemeboardView).x / phonemeboardView.bounds.width
        let y = touch.locationInView(phonemeboardView).y / phonemeboardView.bounds.height
        
        let frequency1 = Float(170000 / max(1, (y * 500.0 + 125)))
        let frequency2 = Float(-4000/M_PI) * Float(atan2(y * 500.0 - 700, x * 500.0 - 250) - 400)
        
        return (frequency1, frequency2)
    }
    
}
