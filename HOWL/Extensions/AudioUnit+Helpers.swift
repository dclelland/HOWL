//
//  AudioUnit+Helpers.swift
//  HOWL
//
//  Created by Daniel Clelland on 25/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreAudio

// MARK: - AudioUnit helpers

extension AudioUnit {
    
    func getValue<T>(for property: AudioUnitPropertyID) -> T {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! getProperty(property, dataSize: dataSize)
    }
    
    func setValue<T>(_ value: T, for property: AudioUnitPropertyID) {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! setProperty(property, dataSize: dataSize, data: value)
    }
    
    func add(listener: AudioUnitPropertyListener, to property: AudioUnitPropertyID) {
        try! addPropertyListener(listener, toProperty: property)
    }
    
    func remove(listener: AudioUnitPropertyListener, from property: AudioUnitPropertyID) {
        try! removePropertyListener(listener, fromProperty: property)
    }
    
}

// MARK: - AudioUnit callbacks

struct AudioUnitPropertyListener {
    
    typealias Callback = (_ audioUnit: AudioUnit, _ property: AudioUnitPropertyID) -> Void
    
    fileprivate let proc: AudioUnitPropertyListenerProc
    fileprivate let procInput: UnsafeMutablePointer<Callback>
    
    init(_ callback: @escaping Callback) {
        self.proc = { (inRefCon, inUnit, inID, inScope, inElement) in
            inRefCon.assumingMemoryBound(to: Callback.self).pointee(inUnit, inID)
        }
        
        self.procInput = UnsafeMutablePointer<Callback>.allocate(capacity: MemoryLayout<Callback>.stride)
        self.procInput.initialize(to: callback)
    }
    
}

// MARK: - AudioUnit function wrappers

private extension AudioUnit {
    
    func getPropertyInfo(_ propertyID: AudioUnitPropertyID) throws -> (dataSize: UInt32, writable: Bool) {
        var dataSize: UInt32 = 0
        var writable: DarwinBoolean = false
        
        try AudioUnitGetPropertyInfo(self, propertyID, kAudioUnitScope_Global, 0, &dataSize, &writable).check()
        
        return (dataSize: dataSize, writable: writable.boolValue)
    }
    
    func getProperty<T>(_ propertyID: AudioUnitPropertyID, dataSize: UInt32) throws -> T {
        var dataSize = dataSize
        var data = UnsafeMutablePointer<T>.allocate(capacity: Int(dataSize))
        defer {
            data.deallocate(capacity: Int(dataSize))
        }
        
        try AudioUnitGetProperty(self, propertyID, kAudioUnitScope_Global, 0, data, &dataSize).check()
        
        return data.pointee
    }
    
    func setProperty<T>(_ propertyID: AudioUnitPropertyID, dataSize: UInt32, data: T) throws {
        var data = data
        
        try AudioFileSetProperty(self, propertyID, dataSize, &data).check()
    }
    
    func addPropertyListener(_ listener: AudioUnitPropertyListener, toProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitAddPropertyListener(self, propertyID, listener.proc, listener.procInput).check()
    }
    
    func removePropertyListener(_ listener: AudioUnitPropertyListener, fromProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitRemovePropertyListenerWithUserData(self, propertyID, listener.proc, listener.procInput).check()
    }
    
}

// MARK: - AudioUnit function validation

private extension OSStatus {
    
    func check() throws {
        if self != noErr {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: nil)
        }
    }
    
}

// MARK: - Four character codes

extension UInt32 {
    
    init(fourCharacterCode: String) {
        assert(fourCharacterCode.characters.count == 4, "String should be four characters long")
        
        let reversed = String(fourCharacterCode.characters.reversed())
        let bytes = (reversed as NSString).utf8String
        let pointer = UnsafeRawPointer(bytes)!.assumingMemoryBound(to: UInt32.self)
        
        self = pointer.pointee.littleEndian
    }
    
    var fourCharacterCode: String {
        var bytes = bigEndian
        return String(bytesNoCopy: &bytes, length: 4, encoding: .ascii, freeWhenDone: false)!
    }
    
}
