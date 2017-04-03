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
    
    @IBOutlet weak var keyboardLeftIntervalControl: AudioControl!
    @IBOutlet weak var keyboardRightIntervalControl: AudioControl!
    
    @IBOutlet weak var envelopeAttackControl: AudioControl!
    @IBOutlet weak var envelopeDecayControl: AudioControl!
    @IBOutlet weak var envelopeSustainControl: AudioControl!
    @IBOutlet weak var envelopeReleaseControl: AudioControl!
    
    @IBOutlet weak var vibratoWaveformControl: AudioControl!
    @IBOutlet weak var vibratoDepthControl: AudioControl!
    @IBOutlet weak var vibratoRateControl: AudioControl!
    
    @IBOutlet weak var tremoloWaveformControl: AudioControl!
    @IBOutlet weak var tremoloDepthControl: AudioControl!
    @IBOutlet weak var tremoloRateControl: AudioControl!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.value)
        keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.value)
        
        for (control, property) in controls {
            control.value = property.value
        }
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(_ button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func resetButtonTapped(_ button: UIButton) {
        keyboardLeftIntervalControl?.value = Float(Settings.keyboardLeftInterval.defaultValue)
        keyboardRightIntervalControl?.value = Float(Settings.keyboardRightInterval.defaultValue)
        
        for (control, property) in controls {
            control.value = property.defaultValue
        }
    }
    
    // MARK: Controls
    
    fileprivate var controls: [AudioControl: Property] {
        guard let client = Audio.client else {
            return [:]
        }
        
        return [
            envelopeAttackControl: client.synthesizer.envelopeAttack,
            envelopeDecayControl: client.synthesizer.envelopeDecay,
            envelopeSustainControl: client.synthesizer.envelopeSustain,
            envelopeReleaseControl: client.synthesizer.envelopeRelease,
            vibratoWaveformControl: client.synthesizer.vibratoWaveform,
            vibratoDepthControl: client.synthesizer.vibratoDepth,
            vibratoRateControl: client.synthesizer.vibratoRate,
            tremoloWaveformControl: client.synthesizer.tremoloWaveform,
            tremoloDepthControl: client.synthesizer.tremoloDepth,
            tremoloRateControl: client.synthesizer.tremoloRate
        ]
    }
    
}

// MARK: Audio control delegate

extension SynthesizerViewController: AudioControlDelegate {
    
    func audioControl(_ audioControl: AudioControl, valueChanged value: Float) {
        controls[audioControl]?.value = value
        
        switch audioControl {
        case keyboardLeftIntervalControl:
            keyboardViewController?.keyboard.leftInterval = Int(value)
            keyboardViewController?.reloadSynthesizer()
            keyboardViewController?.reloadView()
            Settings.keyboardLeftInterval.value = Int(value)
        case keyboardRightIntervalControl:
            keyboardViewController?.keyboard.rightInterval = Int(value)
            keyboardViewController?.reloadSynthesizer()
            keyboardViewController?.reloadView()
            Settings.keyboardRightInterval.value = Int(value)
        case vibratoWaveformControl:
            keyboardViewController?.reloadSynthesizer()
        case tremoloWaveformControl:
            keyboardViewController?.reloadSynthesizer()
        default:
            break
        }
    }
    
    func audioControlTouchesStarted(_ audioControl: AudioControl) {
        switch audioControl {
        case keyboardLeftIntervalControl:
            keyboardViewController?.mode = keyboardViewControllerMode
        case keyboardRightIntervalControl:
            keyboardViewController?.mode = keyboardViewControllerMode
        default:
            break
        }
    }
    
    func audioControlTouchesEnded(_ audioControl: AudioControl) {
        switch audioControl {
        case keyboardLeftIntervalControl:
            keyboardViewController?.mode = keyboardViewControllerMode
        case keyboardRightIntervalControl:
            keyboardViewController?.mode = keyboardViewControllerMode
        default:
            break
        }
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
        if keyboardLeftIntervalControl?.isSelected == true || keyboardRightIntervalControl?.isSelected == true {
            return .showBackground
        }
        
        return .normal
    }
    
}
