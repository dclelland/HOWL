//
//  Audio.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

struct Audio {
    
    static var synthesizer: Synthesizer!
    static var vocoder: Vocoder!
    static var master: Master!
    
    static var instruments: [AKInstrument] {
        return [
            synthesizer,
            vocoder,
            master
        ]
    }
    
    // MARK: - Life cycle
    
    static func start() {
        synthesizer = Synthesizer()
        vocoder = Vocoder(withInput: synthesizer.output)
        master = Master(withInput: vocoder.output)
        
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
        
        AKManager.sharedManager().stop()
        AKManager.sharedManager().resetOrchestra()
    }
    
    // MARK: - Helpers
    
    static var stopsInBackground: Bool {
        return Settings.phonemeboardSustain.value == false && Settings.keyboardSustain.value == false
    }

}
