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
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        print("move")
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        print("cancel")
    }
    
    func multitouchGestureRecognizer(gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        print("end")
    }
    
}
