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
    
    static func start() {
        guard AKManager.sharedManager().isRunning == false else {
            return
        }
        
        client = Audio(audioInputEnabled: Audiobus.client?.controller.isConnectedToSender == true)
    }
    
    static func stop() {
        guard AKManager.sharedManager().isRunning == true && client?.sustained == false else {
            return
        }
        
        AKManager.sharedManager().stop()
        AKManager.sharedManager().resetOrchestra()
        
        client = nil
    }
    
    static func startInput() {
        guard AKSettings.shared().audioInputEnabled == false else {
            return
        }
        
        client = Audio(audioInputEnabled: true)
    }
    
    static func stopInput() {
        guard AKSettings.shared().audioInputEnabled == true else {
            return
        }
        
        client = Audio(audioInputEnabled: false)
    }
    
    // MARK: Initialization
    
    var synthesizer: Synthesizer
    var vocoder: Vocoder
    var master: Master
    
    init(audioInputEnabled: Bool) {
        AKSettings.shared().audioInputEnabled = audioInputEnabled
        
        synthesizer = Synthesizer()
        vocoder = Vocoder(withInput: synthesizer.output)
        master = Master(withInput: vocoder.output)
        
        AKOrchestra.addInstrument(synthesizer)
        AKOrchestra.addInstrument(vocoder)
        AKOrchestra.addInstrument(master)
        
        synthesizer.play()
        vocoder.play()
        master.play()
    }
    
    // MARK: Properties

    private var sustained: Bool {
        return Settings.phonemeboardSustain.value == true || Settings.keyboardSustain.value == true
    }

}
