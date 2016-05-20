//
//  PhonemeboardViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import MultitouchGestureRecognizer
import ProtonomeAudioKitControls

class PhonemeboardViewController: UIViewController {
    
    @IBOutlet weak var phonemeboardView: AudioPlot?
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer? {
        didSet {
            multitouchGestureRecognizer?.sustain = Settings.phonemeboardSustain.value
        }
    }
    
    @IBOutlet weak var holdButton: UIButton? {
        didSet {
            holdButton?.selected = Settings.phonemeboardSustain.value
        }
    }
    
    // MARK: - Life cycle
    
    func refreshAudio() {
        guard let touches = multitouchGestureRecognizer?.touches, location = locationForTouches(touches) else {
            Audio.master.mute()
            return
        }
        
        Audio.master.unmute()
        
        for vocoder in Audio.vocoders {
            vocoder.x.value = Float(location.x)
            vocoder.y.value = Float(location.y)
        }
    }
    
    func refreshView() {
        guard let multitouchState = multitouchGestureRecognizer?.multitouchState, let touches = multitouchGestureRecognizer?.touches else {
            return
        }
        
        phonemeboardView?.highlighted = multitouchState == .Live
        phonemeboardView?.selected = !touches.isEmpty
        
        if let hue = hueForTouches(touches), let saturation = saturationForTouches(touches) {
            phonemeboardView?.colorHue = hue
            phonemeboardView?.colorSaturation = saturation
        }
    }
    
    // MARK: - Button events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func holdButtonTapped(button: UIButton) {
        Settings.phonemeboardSustain.value = !Settings.phonemeboardSustain.value
        multitouchGestureRecognizer?.sustain = Settings.phonemeboardSustain.value
        button.selected = Settings.phonemeboardSustain.value
    }
    
    // MARK: - Private Getters
    
    private func hueForTouches(touches: [UITouch]) -> CGFloat? {
        guard let location = locationForTouches(touches) else {
            return nil
        }
        
        let offset = CGVector(dx: location.x - 0.5, dy: location.y - 0.5)
        let angle = atan2(offset.dx, offset.dy)
        
        return (angle + CGFloat(M_PI)) / (2.0 * CGFloat(M_PI))
    }
    
    private func saturationForTouches(touches: [UITouch]) -> CGFloat? {
        guard let location = locationForTouches(touches) else {
            return nil
        }

        let offset = CGVector(dx: location.x - 0.5, dy: location.y - 0.5)
        let distance = hypot(offset.dx, offset.dy)

        return distance * 2.0
    }
    
    private func locationForTouches(touches: [UITouch]) -> CGPoint? {
        guard let phonemeboardView = phonemeboardView where touches.count > 0 else {
            return nil
        }
        
        let location = touches.reduce(CGPointZero) { (location, touch) -> CGPoint in
            let touchLocation = touch.locationInView(phonemeboardView)
            
            let x = location.x + touchLocation.x / CGFloat(touches.count)
            let y = location.y + touchLocation.y / CGFloat(touches.count)
            
            return CGPoint(x: x, y: y)
        }
        
        return CGPointApplyAffineTransform(location, phonemeboardView.bounds.normalizationTransform())
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension PhonemeboardViewController: MultitouchGestureRecognizerDelegate {
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        refreshAudio()
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        refreshAudio()
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        refreshAudio()
        refreshView()
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        refreshAudio()
        refreshView()
    }
    
}
