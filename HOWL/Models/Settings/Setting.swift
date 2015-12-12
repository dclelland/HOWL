//
//  Setting.swift
//  HOWL
//
//  Created by Daniel Clelland on 12/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

class Setting<T: Persistable> {
    
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        NSUserDefaults.standardUserDefaults().registerDefaults([key: defaultValue as! AnyObject])
    }
    
    var value: T {
        set {
            T.setPersistentValueForKey(key, value: newValue)
        }
        get {
            return T.persistentValueForKey(key)
        }
    }

}

protocol Persistable {
    
    static func persistentValueForKey(key: String) -> Self
    static func setPersistentValueForKey(key: String, value: Self)
    
}

extension Bool: Persistable {
    
    static func persistentValueForKey(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    static func setPersistentValueForKey(key: String, value: Bool) {
        return NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
    }
    
}

extension Int: Persistable {
    
    static func persistentValueForKey(key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    static func setPersistentValueForKey(key: String, value: Int) {
        return NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
    }
    
}

extension Float: Persistable {
    
    static func persistentValueForKey(key: String) -> Float {
        return NSUserDefaults.standardUserDefaults().floatForKey(key)
    }
    
    static func setPersistentValueForKey(key: String, value: Float) {
        return NSUserDefaults.standardUserDefaults().setFloat(value, forKey: key)
    }
    
}
