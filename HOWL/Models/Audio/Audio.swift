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
    
    // MARK: Actions
    
    static func start() {
        if (AKManager.sharedManager().isRunning == false) {
            synthesizer = Synthesizer()
            vocoder = Vocoder(withInput: synthesizer.output)
            master = Master(withInput: vocoder.output)
            
            for instrument in instruments {
                AKOrchestra.addInstrument(instrument)
            }
            
            AKOrchestra.start()
            
            for instrument in instruments {
                instrument.play()
            }
        }
    }
    
    static func stop() {
        if (AKManager.sharedManager().isRunning == true && Audio.sustained == false) {
            for instrument in instruments {
                instrument.stop()
            }
            
            AKManager.sharedManager().stop()
            AKManager.sharedManager().resetOrchestra()
        }
    }
    
    // MARK: Properties
    
    private static var instruments: [AKInstrument] {
        return [
            synthesizer,
            vocoder,
            master
        ]
    }
    
    private static var sustained: Bool {
        return Settings.phonemeboardSustain.value == true || Settings.keyboardSustain.value == true
    }

}
