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
    
    @IBOutlet weak var keyboardLeftIntervalControl: AudioControl? {
        didSet {
            keyboardLeftIntervalControl?.onChangeValue = { value in
                self.keyboardViewController?.keyboard.leftInterval = Int(value)
                self.keyboardViewController?.refreshNotes()
                self.keyboardViewController?.refreshView()
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
                self.keyboardViewController?.refreshNotes()
                self.keyboardViewController?.refreshView()
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
            envelopeAttackControl?.onChangeValue = { value in
                Audio.synthesizer.envelopeAttack.value = value
                Settings.envelopeAttack.value = value
            }
            envelopeAttackControl?.value = Settings.envelopeAttack.value
        }
    }
    
    @IBOutlet weak var envelopeDecayControl: AudioControl? {
        didSet {
            envelopeDecayControl?.onChangeValue = { value in
                Audio.synthesizer.envelopeDecay.value = value
                Settings.envelopeDecay.value = value
            }
            envelopeDecayControl?.value = Settings.envelopeDecay.value
        }
    }
    
    @IBOutlet weak var envelopeSustainControl: AudioControl? {
        didSet {
            envelopeSustainControl?.onChangeValue = { value in
                Audio.synthesizer.envelopeSustain.value = value
                Settings.envelopeSustain.value = value
            }
            envelopeSustainControl?.value = Settings.envelopeSustain.value
        }
    }
    
    @IBOutlet weak var envelopeReleaseControl: AudioControl? {
        didSet {
            envelopeReleaseControl?.onChangeValue = { value in
                Audio.synthesizer.envelopeRelease.value = value
                Settings.envelopeRelease.value = value
            }
            envelopeReleaseControl?.value = Settings.envelopeRelease.value
        }
    }
    
    @IBOutlet weak var vibratoWaveformControl: AudioControl? {
        didSet {
            vibratoWaveformControl?.onChangeValue = { value in
                Audio.synthesizer.vibratoWaveform.value = value
                self.keyboardViewController?.restartNotes()
                Settings.vibratoWaveform.value = value
            }
            vibratoWaveformControl?.value = Settings.vibratoWaveform.value
        }
    }
    
    @IBOutlet weak var vibratoDepthControl: AudioControl? {
        didSet {
            vibratoDepthControl?.onChangeValue = { value in
                Audio.synthesizer.vibratoDepth.value = value
                Settings.vibratoDepth.value = value
            }
            vibratoDepthControl?.value = Settings.vibratoDepth.value
        }
    }
    
    @IBOutlet weak var vibratoRateControl: AudioControl? {
        didSet {
            vibratoRateControl?.onChangeValue = { value in
                Audio.synthesizer.vibratoRate.value = value
                Settings.vibratoRate.value = value
            }
            vibratoRateControl?.value = Settings.vibratoRate.value
        }
    }
    
    @IBOutlet weak var tremoloWaveformControl: AudioControl? {
        didSet {
            tremoloWaveformControl?.onChangeValue = { value in
                Audio.synthesizer.tremoloWaveform.value = value
                self.keyboardViewController?.restartNotes()
                Settings.tremoloWaveform.value = value
            }
            tremoloWaveformControl?.value = Settings.tremoloWaveform.value
        }
    }
    
    @IBOutlet weak var tremoloDepthControl: AudioControl? {
        didSet {
            tremoloDepthControl?.onChangeValue = { value in
                Audio.synthesizer.tremoloDepth.value = value
                Settings.tremoloDepth.value = value
            }
            tremoloDepthControl?.value = Settings.tremoloDepth.value
        }
    }
    
    @IBOutlet weak var tremoloRateControl: AudioControl? {
        didSet {
            tremoloRateControl?.onChangeValue = { value in
                Audio.synthesizer.tremoloRate.value = value
                Settings.tremoloRate.value = value
            }
            tremoloRateControl?.value = Settings.tremoloRate.value
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
        keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
        
        envelopeAttackControl?.value = Settings.envelopeAttack.defaultValue
        envelopeDecayControl?.value = Settings.envelopeDecay.defaultValue
        envelopeSustainControl?.value = Settings.envelopeSustain.defaultValue
        envelopeReleaseControl?.value = Settings.envelopeRelease.defaultValue
        
        vibratoWaveformControl?.value = Settings.vibratoWaveform.defaultValue
        vibratoDepthControl?.value = Settings.vibratoDepth.defaultValue
        vibratoRateControl?.value = Settings.vibratoRate.defaultValue
        
        tremoloWaveformControl?.value = Settings.tremoloWaveform.defaultValue
        tremoloDepthControl?.value = Settings.tremoloDepth.defaultValue
        tremoloRateControl?.value = Settings.tremoloRate.defaultValue
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
