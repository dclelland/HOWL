//
//  VocoderViewController.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import ProtonomeAudioKitControls

class VocoderViewController: UIViewController {
    
    @IBOutlet weak var flipButton: UIButton?
    
    @IBOutlet weak var inputButton: UIButton? {
        didSet {
            inputButton?.selected = Audio.client!.vocoder.inputEnabled
        }
    }
    
    @IBOutlet weak var formantsFrequencyControl: AudioControl? {
        didSet {
            formantsFrequencyControl?.value = Audio.client!.vocoder.formantsFrequency.value
            formantsFrequencyControl?.onChangeValue = { value in
                Audio.client?.vocoder.formantsFrequency.value = value
            }
        }
    }
    
    @IBOutlet weak var formantsBandwidthControl: AudioControl? {
        didSet {
            formantsBandwidthControl?.value = Audio.client!.vocoder.formantsBandwidth.value
            formantsBandwidthControl?.onChangeValue = { value in
                Audio.client?.vocoder.formantsBandwidth.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsBitcrushControl: AudioControl? {
        didSet {
            effectsBitcrushControl?.value = Audio.client!.master.effectsBitcrush.value
            effectsBitcrushControl?.onChangeValue = { value in
                Audio.client?.master.effectsBitcrush.value = value
            }
        }
    }
    
    @IBOutlet weak var effectsReverbControl: AudioControl? {
        didSet {
            effectsReverbControl?.value = Audio.client!.master.effectsReverb.value
            effectsReverbControl?.onChangeValue = { value in
                Audio.client?.master.effectsReverb.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXShapeControl: AudioControl? {
        didSet {
            lfoXShapeControl?.value = Audio.client!.vocoder.lfoXShape.value
            lfoXShapeControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXShape.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXDepthControl: AudioControl? {
        didSet {
            lfoXDepthControl?.value = Audio.client!.vocoder.lfoXDepth.value
            lfoXDepthControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoXRateControl: AudioControl? {
        didSet {
            lfoXRateControl?.value = Audio.client!.vocoder.lfoXRate.value
            lfoXRateControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoXRate.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYShapeControl: AudioControl? {
        didSet {
            lfoYShapeControl?.value = Audio.client!.vocoder.lfoYShape.value
            lfoYShapeControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYShape.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYDepthControl: AudioControl? {
        didSet {
            lfoYDepthControl?.value = Audio.client!.vocoder.lfoYDepth.value
            lfoYDepthControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYDepth.value = value
            }
        }
    }
    
    @IBOutlet weak var lfoYRateControl: AudioControl? {
        didSet {
            lfoYRateControl?.value = Audio.client!.vocoder.lfoYRate.value
            lfoYRateControl?.onChangeValue = { value in
                Audio.client?.vocoder.lfoYRate.value = value
            }
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(Settings.didResetNotification, object: nil, queue: nil) { notification in
            self.formantsFrequencyControl?.value = Audio.client!.vocoder.formantsFrequency.defaultValue
            self.formantsBandwidthControl?.value = Audio.client!.vocoder.formantsBandwidth.defaultValue
            
            self.effectsBitcrushControl?.value = Audio.client!.master.effectsBitcrush.defaultValue
            self.effectsReverbControl?.value = Audio.client!.master.effectsReverb.defaultValue
            
            self.lfoXShapeControl?.value = Audio.client!.vocoder.lfoXShape.defaultValue
            self.lfoXDepthControl?.value = Audio.client!.vocoder.lfoXDepth.defaultValue
            self.lfoXRateControl?.value = Audio.client!.vocoder.lfoXRate.defaultValue
            
            self.lfoYShapeControl?.value = Audio.client!.vocoder.lfoYShape.defaultValue
            self.lfoYDepthControl?.value = Audio.client!.vocoder.lfoYDepth.defaultValue
            self.lfoYRateControl?.value = Audio.client!.vocoder.lfoYRate.defaultValue
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(Audiobus.didUpdateConnections, object: nil, queue: nil) { notification in
            self.inputButton?.selected = Audio.client!.vocoder.inputEnabled
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Settings.didResetNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Audiobus.didUpdateConnections, object: nil)
    }
    
    // MARK: - Interface events
    
    @IBAction func flipButtonTapped(button: UIButton) {
        flipViewController?.flip()
    }
    
    @IBAction func inputButtonTapped(button: UIButton) {
        Audio.client!.vocoder.inputEnabled = !Audio.client!.vocoder.inputEnabled
        inputButton?.selected = Audio.client!.vocoder.inputEnabled
    }
    
}
