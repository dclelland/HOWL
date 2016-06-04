//
//  Persist.swift
//  Persist
//
//  Created by Daniel Clelland on 4/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Persistent struct

/// A simple struct which takes a value and persists it across sessions.
struct Persistent<T: PersistableType>: Persistable {
    
    typealias PersistentType = T
    
    var value: T {
        set {
            setPersistentValue(value)
        }
        get {
            return persistentValue()
        }
    }
    
    let defaultValue: T
    
    let persistentKey: String
    
    init(value: T, key: String) {
        self.defaultValue = value
        self.persistentKey = key
        
        self.setDefaultPersistentValue(value)
    }
    
}

// MARK: Persistable protocol

/// An abstract protocol which can be used to add a persistent value to existing classes and structs.
protocol Persistable {
    
    associatedtype PersistentType: PersistableType
    
    var persistentKey: String { get }
    
}

extension Persistable {
    
    func persistentValue() -> PersistentType {
        return PersistentType(persistentObject: NSUserDefaults.standardUserDefaults().objectForKey(persistentKey)!)
    }
    
    func setPersistentValue(value: PersistentType) {
        NSUserDefaults.standardUserDefaults().setObject(value.persistentObject, forKey: persistentKey)
    }
    
    func setDefaultPersistentValue(value: PersistentType) {
        NSUserDefaults.standardUserDefaults().registerDefaults([persistentKey: value.persistentObject])
    }
    
}

/// An abstract protocol which can be used to make existing objects persistable.
protocol PersistableType {
    
    init(persistentObject: AnyObject)
    var persistentObject: AnyObject { get }

}

extension Bool: PersistableType {

    init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).boolValue
    }
    
    var persistentObject: AnyObject {
        return NSNumber(bool: self)
    }

}

extension Int: PersistableType {
    
    init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).integerValue
    }
    
    var persistentObject: AnyObject {
        return NSNumber(integer: self)
    }

}

extension Float: PersistableType {
    
    init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).floatValue
    }
    
    var persistentObject: AnyObject {
        return NSNumber(float: self)
    }

}

extension Double: PersistableType {
    
    init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).doubleValue
    }
    
    var persistentObject: AnyObject {
        return NSNumber(double: self)
    }

}
