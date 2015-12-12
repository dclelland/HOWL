//
//  Audio.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

struct Audio {
    
    static let synthesizer = Synthesizer()
    
    static let sopranoVocoder = Vocoder(withInput: synthesizer.output)
    static let altoVocoder = Vocoder(withInput: synthesizer.output)
    static let tenorVocoder = Vocoder(withInput: synthesizer.output)
    static let bassVocoder = Vocoder(withInput: synthesizer.output)
    
    static let master = Master(
        withInput: synthesizer.output,
        voices: [
            sopranoVocoder.output,
            altoVocoder.output,
            tenorVocoder.output,
            bassVocoder.output
        ]
    )
    
    static var instruments: [AKInstrument] {
        return [
            synthesizer,
            sopranoVocoder,
            altoVocoder,
            tenorVocoder,
            bassVocoder,
            master
        ]
    }
    
    // MARK: - Life cycle
    
    static func start() {
        for instrument in instruments {
            AKOrchestra.addInstrument(instrument)
        }
        
        AKOrchestra.start()
    }
    
    static func play() {
        for instrument in instruments {
            instrument.play()
        }
    }
    
    static func stop() {
        for instrument in instruments {
            instrument.stop()
        }
    }

}
