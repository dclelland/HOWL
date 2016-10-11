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
    
    static let didStartNotification = NSNotification.Name("AudioDidStartNotification")
    
    static func start() {
        guard AKManager.shared().isRunning == false else {
            return
        }
        
        client = Audio()
        
        NotificationCenter.default.post(name: didStartNotification, object: nil, userInfo: nil)
    }
    
    static let didStopNotification = NSNotification.Name("AudioDidStopNotification")
    
    static func stop() {
        guard AKManager.shared().isRunning == true else {
            return
        }
        
        client = nil
        
        AKManager.shared().stop()
        AKManager.shared().resetOrchestra()
        
        NotificationCenter.default.post(name: didStopNotification, object: nil, userInfo: nil)
    }
    
    // MARK: Initialization
    
    var synthesizer: Synthesizer
    var vocoder: Vocoder
    var master: Master
    
    init() {
        synthesizer = Synthesizer()
        vocoder = Vocoder(input: synthesizer.output)
        master = Master(input: vocoder.output)
        
        AKOrchestra.reset()
        AKOrchestra.add(synthesizer)
        AKOrchestra.add(vocoder)
        AKOrchestra.add(master)
        
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
