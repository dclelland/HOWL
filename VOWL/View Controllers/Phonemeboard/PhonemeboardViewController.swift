//
//  PhonemeboardViewController.swift
//  VOWL
//
//  Created by Daniel Clelland on 14/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class PhonemeboardViewController: UIViewController, PhonemeboardViewDelegate {
    
    @IBOutlet weak var phonemeboardView: PhonemeboardView?
    
    let phonemeboard = Phonemeboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phonemeboardView?.delegate = self
    }
    
    // MARK: - Interface events
    
    @IBAction func holdButtonTapped(button: UIButton) {
        print("hold button tapped")
    }
    
    // MARK: Phonemeboard view delegate
    
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchBegan touch: UITouch) {
        print("began: " + NSStringFromCGPoint(touch.locationInView(phonemeboardView)))
    }
    
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchMoved touch: UITouch) {
        print("moved: " + NSStringFromCGPoint(touch.locationInView(phonemeboardView)))
    }
    
    func phonemeboardView(phonemeboardView: PhonemeboardView, touchEnded touch: UITouch) {
        print("ended: " + NSStringFromCGPoint(touch.locationInView(phonemeboardView)))
    }
    
}
