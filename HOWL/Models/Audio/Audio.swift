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
    
    static var client: Audio?
    
    // MARK: Actions
    
    static let didStartNotification = "AudioDidStartNotification"
    
    static func start() {
        guard AKManager.sharedManager().isRunning == false else {
            return
        }
        
        client = Audio()
        
        NSNotificationCenter.defaultCenter().postNotificationName(didStartNotification, object: nil, userInfo: nil)
    }
    
    static let didStopNotification = "AudioDidStopNotification"
    
    static func stop() {
        guard AKManager.sharedManager().isRunning == true else {
            return
        }
        
        client = nil
        
        AKManager.sharedManager().stop()
        AKManager.sharedManager().resetOrchestra()
        
        NSNotificationCenter.defaultCenter().postNotificationName(didStopNotification, object: nil, userInfo: nil)
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

}
