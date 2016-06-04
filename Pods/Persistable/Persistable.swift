//
//  Persistable.swift
//  Persistable
//
//  Created by Daniel Clelland on 4/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Persistent

/// A simple struct which takes a value and persists it across sessions.
public struct Persistent<T: PersistableType>: Persistable {
    
    /// The type of the persistent value.
    public typealias PersistentType = T
    
    /// Alias around `persistentValue` and `setPersistentValue:`.
    public var value: T {
        set {
            setPersistentValue(newValue)
        }
        get {
            return persistentValue()
        }
    }
    
    /// The default persistent value.
    public let defaultValue: T
    
    /// The key used to store the persistent value.
    public let persistentKey: String
    
    /**
     Creates a new Persistent value struct.
     
     - parameter value: The initial value. Used to register a default value with NSUserDefaults.
     - parameter key: The key used to set and get the value in NSUserDefaults.
     */
    public init(value: T, key: String) {
        self.defaultValue = value
        self.persistentKey = key
        
        self.setDefaultPersistentValue(value)
    }
    
}

// MARK: Persistable

/// An abstract protocol which can be used to add a persistent value to existing classes and structs.
public protocol Persistable {
    
    /// The type of the persistent value
    associatedtype PersistentType: PersistableType
    
    /// The key used to set the persistent value in NSUserDefaults
    var persistentKey: String { get }
    
}

extension Persistable {
    
    /// Get the persistent value from NSUserDefaults.
    public func persistentValue() -> PersistentType {
        return PersistentType(persistentObject: NSUserDefaults.standardUserDefaults().objectForKey(persistentKey)!)
    }
    
    /// Set the persistent value in NSUserDefaults.
    public func setPersistentValue(value: PersistentType) {
        NSUserDefaults.standardUserDefaults().setObject(value.persistentObject, forKey: persistentKey)
    }
    
    /// Register a default value with NSUserDefaults.
    public func setDefaultPersistentValue(value: PersistentType) {
        NSUserDefaults.standardUserDefaults().registerDefaults([persistentKey: value.persistentObject])
    }
    
}

// MARK: Persistable Type

/// An abstract protocol which can be used to make existing objects persistable.
public protocol PersistableType {
    
    /// Creates a new value using an object returned from NSUserDefaults.
    init(persistentObject: AnyObject)
    
    /// Create a new object which can be saved in NSUserDefaults.
    var persistentObject: AnyObject { get }

}

/// Boolean persistable type implementation
extension Bool: PersistableType {

    public init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).boolValue
    }
    
    public var persistentObject: AnyObject {
        return NSNumber(bool: self)
    }

}

/// Integer persistable type implementation
extension Int: PersistableType {
    
    public init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).integerValue
    }
    
    public var persistentObject: AnyObject {
        return NSNumber(integer: self)
    }

}

/// Float persistable type implementation
extension Float: PersistableType {
    
    public init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).floatValue
    }
    
    public var persistentObject: AnyObject {
        return NSNumber(float: self)
    }

}


/// Double persistable type implementation
extension Double: PersistableType {
    
    public init(persistentObject: AnyObject) {
        self = (persistentObject as! NSNumber).doubleValue
    }
    
    public var persistentObject: AnyObject {
        return NSNumber(double: self)
    }

}
