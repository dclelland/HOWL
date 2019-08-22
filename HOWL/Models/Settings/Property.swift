//
//  InstrumentProperty.swift
//  HOWL
//
//  Created by Daniel Clelland on 2/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import AudioKit
import Persistable

// MARK: Instrument properties

class Property: AKInstrumentProperty, Persistable {
    
    typealias PersistentType = Float
    
    override var value: Float {
        didSet {
            self.persistentValue = value
        }
    }
    
    let defaultValue: Float
    
    let persistentKey: String
    
    init(value: Float, key: String) {
        self.defaultValue = value
        self.persistentKey = key
        
        super.init()
        
        self.register(defaultPersistentValue: value)
        
        self.value = self.persistentValue
        self.initialValue = value
    }
    
}

// MARK: Instruments

extension AKInstrument {
    
    var persistentProperties: [Property] {
        return properties.compactMap { $0 as? Property }
    }
    
    func reset() {
        for property in persistentProperties {
            property.reset()
        }
    }
    
}
