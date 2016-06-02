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
                self.keyboardViewController?.restartNotes()
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
                self.keyboardViewController?.restartNotes()
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
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(button: UIButton) {
        keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
        keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
        
        envelopeAttackControl?.value = Audio.client!.synthesizer.envelopeAttack.initialValue
        envelopeDecayControl?.value = Audio.client!.synthesizer.envelopeDecay.initialValue
        envelopeSustainControl?.value = Audio.client!.synthesizer.envelopeSustain.initialValue
        envelopeReleaseControl?.value = Audio.client!.synthesizer.envelopeRelease.initialValue
        
        vibratoWaveformControl?.value = Audio.client!.synthesizer.vibratoWaveform.initialValue
        vibratoDepthControl?.value = Audio.client!.synthesizer.vibratoDepth.initialValue
        vibratoRateControl?.value = Audio.client!.synthesizer.vibratoRate.initialValue
        
        tremoloWaveformControl?.value = Audio.client!.synthesizer.tremoloWaveform.initialValue
        tremoloDepthControl?.value = Audio.client!.synthesizer.tremoloDepth.initialValue
        tremoloRateControl?.value = Audio.client!.synthesizer.tremoloRate.initialValue
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
