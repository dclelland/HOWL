//
//  InstrumentProperty.swift
//  HOWL
//
//  Created by Daniel Clelland on 2/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit

class InstrumentProperty: AKInstrumentProperty {
    
    var key: String? = nil
    
    convenience init(value: Float, key: String) {
        NSUserDefaults.standardUserDefaults().registerDefaults([key: value])
        
        self.init(value: NSUserDefaults.standardUserDefaults().floatForKey(key))
        self.initialValue = value
        self.key = key
    }
    
    override var value: Float {
        didSet {
            if let key = key {
                NSUserDefaults.standardUserDefaults().setFloat(value, forKey: key)
            }
        }
    }
    
}
