//
//  Audio.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Audio {
    
    static let shared = Audio()
    
    let synthesizer: Synthesizer
    let vocoder: Vocoder
    let master: Master
    
    init() {
        self.synthesizer = Synthesizer()
        self.vocoder = Vocoder.init(withInput: self.synthesizer.output)
        self.master = Master.init(withInput: self.vocoder.output)
    }
    
    // MARK: - Getters
    
    func instruments() -> [AKInstrument] {
        return [
            self.synthesizer,
            self.vocoder,
            self.master
        ]
    }
    
    // MARK: - Life cycle
    
    func start() {
        for instrument in self.instruments() {
            AKOrchestra.addInstrument(instrument)
        }
        
        AKOrchestra.start()
    }
    
    func play() {
        for instrument in self.instruments() {
            instrument.play()
        }
        
        self.synthesizer.playNote(SynthesizerNote(withFrequency: 440.0))
    }
    
    func stop() {
        for instrument in self.instruments() {
            instrument.stop()
        }
    }

}
