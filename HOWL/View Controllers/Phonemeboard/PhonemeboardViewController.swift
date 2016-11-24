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
    
    @IBOutlet weak var phonemeboardView: PhonemeboardView!
    
    @IBOutlet weak var multitouchGestureRecognizer: MultitouchGestureRecognizer! {
        didSet {
            multitouchGestureRecognizer.sustain = Settings.phonemeboardSustain.value
        }
    }
    
    @IBOutlet weak var flipButton: UIButton?
    
    @IBOutlet weak var holdButton: UIButton? {
        didSet {
            holdButton?.isSelected = Settings.phonemeboardSustain.value
        }
    }
    
    // MARK: - Overrides
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Audio.didStartNotification, object: nil, queue: nil) { notification in
            self.reloadVocoder()
        }
    }
    
    // MARK: - Life cycle
    
    func reloadVocoder() {
        guard let location = phonemeboardLocation else {
            Audio.client?.vocoder.enabled = false
            return
        }
        
        Audio.client?.vocoder.enabled = true
        Audio.client?.vocoder.location = location
    }
    
    func stopVocoder() {
        Audio.client?.vocoder.enabled = false
    }
    
    func reloadView() {
        phonemeboardView.isHighlighted = multitouchGestureRecognizer.multitouchState == .live
        phonemeboardView.isSelected = multitouchGestureRecognizer.touches.isEmpty == false
    }
    
    // MARK: - Button events
    
    @IBAction func flipButtonTapped(_ button: UIButton) {
        flipViewController?.flip()
        
        if !Settings.phonemeboardSustain.value {
            stopVocoder()
            reloadView()
        }
    }
    
    @IBAction func holdButtonTapped(_ button: UIButton) {
        let sustain = !Settings.phonemeboardSustain.value
        
        holdButton?.isSelected = sustain
        Settings.phonemeboardSustain.value = sustain
        multitouchGestureRecognizer.sustain = sustain
    }
    
    // MARK: - Private getters
    
    private var phonemeboardLocation: CGPoint? {
        return multitouchGestureRecognizer.centroid?.clamp(rect: phonemeboardView.bounds).ilerp(rect: phonemeboardView.bounds)
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension PhonemeboardViewController: MultitouchGestureRecognizerDelegate {
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        reloadVocoder()
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
        reloadVocoder()
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        reloadVocoder()
        reloadView()
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        reloadVocoder()
        reloadView()
    }
    
}
