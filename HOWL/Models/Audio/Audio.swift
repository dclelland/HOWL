//
//  Audio.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

class Audio {
    
    // MARK: Client
    
    static var client: Audio? {
        didSet {
            didSetClient?()
        }
    }
    
    static var didSetClient: (Void -> Void)?
    
    // MARK: Actions
    
    static func start() {
        guard AKManager.sharedManager().isRunning == false else {
            return
        }
        
        client = Audio()
    }
    
    static func stop() {
        guard AKManager.sharedManager().isRunning == true && client?.sustained == false else {
            return
        }
        
        client = nil
        
        AKManager.sharedManager().stop()
        AKManager.sharedManager().resetOrchestra()
    }
    
    static let didResetNotification = "AudioDidResetNotification"
    
    static func reset() {
        guard let client = client else {
            return
        }
        
        client.synthesizer.reset()
        client.vocoder.reset()
        client.master.reset()
        
        NSNotificationCenter.defaultCenter().postNotificationName(didResetNotification, object: nil, userInfo: nil)
    }
    
    // MARK: Initialization
    
    var synthesizer: Synthesizer
    var vocoder: Vocoder
    var master: Master
    
    init() {
        synthesizer = Synthesizer()
        vocoder = Vocoder(withInput: synthesizer.output)
        master = Master(withInput: vocoder.output)
        
        AKOrchestra.reset()
        AKOrchestra.addInstrument(synthesizer)
        AKOrchestra.addInstrument(vocoder)
        AKOrchestra.addInstrument(master)
        
        synthesizer.start()
        vocoder.start()
        master.start()
    }
    
    deinit {
        synthesizer.stop()
        vocoder.stop()
        master.stop()
    }
    
    // MARK: Properties

    private var sustained: Bool {
        return Settings.phonemeboardSustain.value == true || Settings.keyboardSustain.value == true
    }

}
