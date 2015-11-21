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
        Audio.shared.vocoder.startWithFrequencies(self.frequenciesForTouches(gestureRecognizer.touches))
        
        self.phonemeboardView?.backgroundColor = self.colorForTouches(gestureRecognizer.touches)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        Audio.shared.vocoder.updateWithFrequencies(self.frequenciesForTouches(gestureRecognizer.touches))
        
        self.phonemeboardView?.backgroundColor = self.colorForTouches(gestureRecognizer.touches)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        Audio.shared.vocoder.stopWithFrequencies(self.frequenciesForTouches(gestureRecognizer.touches))
        
        self.phonemeboardView?.backgroundColor = self.colorForTouches(gestureRecognizer.touches)
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        Audio.shared.vocoder.stopWithFrequencies(self.frequenciesForTouches(gestureRecognizer.touches))
        
        self.phonemeboardView?.backgroundColor = self.colorForTouches(gestureRecognizer.touches)
    }
    
    // MARK: - Frequencies
    
    private func frequenciesForTouches(touches: [UITouch]) -> (Float, Float) {
        guard let location = self.locationForTouches(touches) else {
            return (0.0, 0.0)
        }
        
        let frequency1 = Float(170000 / max(1, (location.y * 500.0 + 125)))
        let frequency2 = Float(-4000/M_PI) * Float(atan2(location.y * 500.0 - 700, location.x * 500.0 - 250) - 400)
        
        return (frequency1, frequency2)
    }
    
    private func colorForTouches(touches: [UITouch]) -> UIColor {
        guard let location = self.locationForTouches(touches) else {
            return UIColor.VOWL.darkGreyColor()
        }
        
        let offset = CGVectorMake(location.x - 0.5, location.y - 0.5)
        
        let angle = atan2(offset.dx, offset.dy)
        let distance = hypot(offset.dx, offset.dy)
        
        let hue = (angle + CGFloat(M_PI)) / (2.0 * CGFloat(M_PI))
        let saturation = distance * 2.0
        
        return UIColor.VOWL.lightColor(withHue: hue, saturation: saturation)
    }
    
    private func locationForTouches(touches: [UITouch]) -> CGPoint? {
        guard let phonemeboardView = self.phonemeboardView where touches.count > 0 else {
            return nil
        }
        
        let location = touches.reduce(CGPointZero) { (location, touch) -> CGPoint in
            let touchLocation = touch.locationInView(phonemeboardView)
            
            let x = location.x + touchLocation.x / CGFloat(touches.count)
            let y = location.y + touchLocation.y / CGFloat(touches.count)
            
            return CGPointMake(x, y)
        }
        
        return CGPointApplyAffineTransform(location, phonemeboardView.bounds.normalizationTransform())
    }
    
}
