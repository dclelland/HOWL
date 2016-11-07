//
//  Audio.swift
//  HOWL
//
//  Created by Daniel Clelland on 3/07/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class Audio {
    
    static let client = Audio()
    
    let synthesizer: Synthesizer
    let vocoder: Vocoder
    let master: Master
    
    init() {
        self.synthesizer = Synthesizer()
        
        let oscillator = AKOscillator(waveform: AKTable(.sawtooth, size: 2048))
        oscillator.amplitude = 0.25
        oscillator.frequency = 120.0
        oscillator.start()
        
        self.vocoder = Vocoder(withInput: oscillator)
//        self.master = Master(withInput: self.vocoder)
        self.master = Master(withInput: oscillator)
        
        AudioKit.output = self.master
    }
    
    static let didStartNotification = NSNotification.Name("AudioDidStartNotification")
    
    func start() {
        AudioKit.start()
        
        NotificationCenter.default.post(name: Audio.didStartNotification, object: nil, userInfo: nil)
    }
    
    static let didStopNotification = NSNotification.Name("AudioDidStopNotification")
    
    func stop() {
        AudioKit.stop()
        
        NotificationCenter.default.post(name: Audio.didStopNotification, object: nil, userInfo: nil)
    }
    
}
