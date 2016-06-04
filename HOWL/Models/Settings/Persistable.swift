//
//  Persistable.swift
//  HOWL
//
//  Created by Daniel Clelland on 4/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

protocol Persistable {
    
    associatedtype PersistentType: PersistableType
    
    var persistentKey: String { get }
    
}

extension Persistable {
    
    var persistentValue: PersistentType {
        set {
            PersistentType.setPersistentValue(newValue, forKey: persistentKey)
        }
        get {
            return PersistentType.persistentValue(forKey: persistentKey)
        }
    }
    
    func setDefaultPersistentValue(value: PersistentType) {
        PersistentType.setDefaultPersistentValue(value, forKey: persistentKey)
    }
    
}

protocol PersistableType {
    
    static func persistentValue(forKey key: String) -> Self
    static func setPersistentValue(value: Self, forKey key: String)
    
}

extension PersistableType {
    
    static func setDefaultPersistentValue(value: Self, forKey key: String) {
        NSUserDefaults.standardUserDefaults().registerDefaults([key: value as! AnyObject])
    }

}

extension Bool: PersistableType {
    
    static func persistentValue(forKey key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    static func setPersistentValue(value: Bool, forKey key: String) {
        return NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
    }
    
}

extension Int: PersistableType {
    
    static func persistentValue(forKey key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    static func setPersistentValue(value: Int, forKey key: String) {
        return NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
    }
    
}

extension Float: PersistableType {
    
    static func persistentValue(forKey key: String) -> Float {
        return NSUserDefaults.standardUserDefaults().floatForKey(key)
    }
    
    static func setPersistentValue(value: Float, forKey key: String) {
        return NSUserDefaults.standardUserDefaults().setFloat(value, forKey: key)
    }
    
}

extension Double: PersistableType {
    
    static func persistentValue(forKey key: String) -> Double {
        return NSUserDefaults.standardUserDefaults().doubleForKey(key)
    }
    
    static func setPersistentValue(value: Double, forKey key: String) {
        return NSUserDefaults.standardUserDefaults().setDouble(value, forKey: key)
    }
    
}