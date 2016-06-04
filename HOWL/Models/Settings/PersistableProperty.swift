//
//  Property.swift
//  HOWL
//
//  Created by Daniel Clelland on 4/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

struct PersistableProperty<T: PersistableType>: Persistable {
    
    typealias PersistentType = T
    
    var persistentKey: String
    
    var defaultValue: T {
        didSet {
            setDefaultPersistentValue(defaultValue)
        }
    }
    
    var value: T {
        set {
            persistentValue = newValue
        }
        get {
            return persistentValue
        }
    }
    
    init(value: T, key: String) {
        self.persistentKey = key
        self.defaultValue = value
    }
    
}
