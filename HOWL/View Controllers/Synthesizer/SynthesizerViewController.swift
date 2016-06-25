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
    
    @IBOutlet weak var flipButton: UIButton?
    
    @IBOutlet weak var resetButton: UIButton?
    
    @IBOutlet weak var keyboardLeftIntervalControl: AudioControl? {
        didSet {
            keyboardLeftIntervalControl?.onChangeValue = { value in
                self.keyboardViewController?.keyboard.leftInterval = Int(value)
                self.keyboardViewController?.reloadSynthesizer()
                self.keyboardViewController?.reloadView()
                Settings.keyboardLeftInterval.value = Int(value)
            }
            keyboardLeftIntervalControl?.onTouchDown = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardLeftIntervalControl?.onTouchUp = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.value)
        }
    }
    
    @IBOutlet weak var keyboardRightIntervalControl: AudioControl? {
        didSet {
            keyboardRightIntervalControl?.onChangeValue = { value in
                self.keyboardViewController?.keyboard.rightInterval = Int(value)
                self.keyboardViewController?.reloadSynthesizer()
                self.keyboardViewController?.reloadView()
                Settings.keyboardRightInterval.value = Int(value)
            }
            keyboardRightIntervalControl?.onTouchDown = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardRightIntervalControl?.onTouchUp = {
                self.keyboardViewController?.mode = self.keyboardViewControllerMode
            }
            keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.value)
        }
    }
    
    @IBOutlet weak var envelopeAttackControl: AudioControl? {
        didSet {
            envelopeAttackControl?.value = Audio.client!.synthesizer.envelopeAttack.value
            envelopeAttackControl?.onChangeValue = { value in
                Audio.client?.synthesizer.envelopeAttack.value = value
            }
        }
    }
    
    @IBOutlet weak var envelopeDecayControl: AudioControl? {
        didSet {
            envelopeDecayControl?.value = Audio.client!.synthesizer.envelopeDecay.value
            envelopeDecayControl?.onChangeValue = { value in
                Audio.client?.synthesizer.envelopeDecay.value = value
            }
        }
    }
    
    @IBOutlet weak var envelopeSustainControl: AudioControl? {
        didSet {
            envelopeSustainControl?.value = Audio.client!.synthesizer.envelopeSustain.value
            envelopeSustainControl?.onChangeValue = { value in
                Audio.client?.synthesizer.envelopeSustain.value = value
            }
        }
    }
    
    @IBOutlet weak var envelopeReleaseControl: AudioControl? {
        didSet {
            envelopeReleaseControl?.value = Audio.client!.synthesizer.envelopeRelease.value
            envelopeReleaseControl?.onChangeValue = { value in
                Audio.client?.synthesizer.envelopeRelease.value = value
            }
        }
    }
    
    @IBOutlet weak var vibratoWaveformControl: AudioControl? {
        didSet {
            vibratoWaveformControl?.value = Audio.client!.synthesizer.vibratoWaveform.value
            vibratoWaveformControl?.onChangeValue = { value in
                Audio.client?.synthesizer.vibratoWaveform.value = value
                self.keyboardViewController?.reloadSynthesizer()
            }
        }
    }
    
    @IBOutlet weak var vibratoDepthControl: AudioControl? {
        didSet {
            vibratoDepthControl?.value = Audio.client!.synthesizer.vibratoDepth.value
            vibratoDepthControl?.onChangeValue = { value in
                Audio.client?.synthesizer.vibratoDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var vibratoRateControl: AudioControl? {
        didSet {
            vibratoRateControl?.value = Audio.client!.synthesizer.vibratoRate.value
            vibratoRateControl?.onChangeValue = { value in
                Audio.client?.synthesizer.vibratoRate.value = value
            }
        }
    }
    
    @IBOutlet weak var tremoloWaveformControl: AudioControl? {
        didSet {
            tremoloWaveformControl?.value = Audio.client!.synthesizer.tremoloWaveform.value
            tremoloWaveformControl?.onChangeValue = { value in
                Audio.client?.synthesizer.tremoloWaveform.value = value
                self.keyboardViewController?.reloadSynthesizer()
            }
        }
    }
    
    @IBOutlet weak var tremoloDepthControl: AudioControl? {
        didSet {
            tremoloDepthControl?.value = Audio.client!.synthesizer.tremoloDepth.value
            tremoloDepthControl?.onChangeValue = { value in
                Audio.client?.synthesizer.tremoloDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var tremoloRateControl: AudioControl? {
        didSet {
            tremoloRateControl?.value = Audio.client!.synthesizer.tremoloRate.value
            tremoloRateControl?.onChangeValue = { value in
                Audio.client?.synthesizer.tremoloRate.value = value
            }
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(Audio.didResetNotification, object: nil, queue: nil) { notification in
            self.keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
            self.keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(Settings.didResetNotification, object: nil, queue: nil) { notification in
            self.envelopeAttackControl?.value = Audio.client!.synthesizer.envelopeAttack.defaultValue
            self.envelopeDecayControl?.value = Audio.client!.synthesizer.envelopeDecay.defaultValue
            self.envelopeSustainControl?.value = Audio.client!.synthesizer.envelopeSustain.defaultValue
            self.envelopeReleaseControl?.value = Audio.client!.synthesizer.envelopeRelease.defaultValue
            
            self.vibratoWaveformControl?.value = Audio.client!.synthesizer.vibratoWaveform.defaultValue
            self.vibratoDepthControl?.value = Audio.client!.synthesizer.vibratoDepth.defaultValue
            self.vibratoRateControl?.value = Audio.client!.synthesizer.vibratoRate.defaultValue
            
            self.tremoloWaveformControl?.value = Audio.client!.synthesizer.tremoloWaveform.defaultValue
            self.tremoloDepthControl?.value = Audio.client!.synthesizer.tremoloDepth.defaultValue
            self.tremoloRateControl?.value = Audio.client!.synthesizer.tremoloRate.defaultValue
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Audio.didResetNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Settings.didResetNotification, object: nil)
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        Audio.reset()
        Settings.reset()
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
        if keyboardLeftIntervalControl?.selected == true || keyboardRightIntervalControl?.selected == true {
            return .ShowBackground
        }
        
        return .Normal
    }
    
}
