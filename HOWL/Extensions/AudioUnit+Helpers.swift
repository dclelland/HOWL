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
    
    func getValue<T>(forProperty property: AudioUnitPropertyID) -> T {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! getProperty(property, dataSize: dataSize)
    }
    
    func setValue<T>(value: T, forProperty property: AudioUnitPropertyID) {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! setProperty(property, dataSize: dataSize, data: value)
    }
    
    func add(listener listener: AudioUnitPropertyListener, toProperty property: AudioUnitPropertyID) {
        try! addPropertyListener(listener, toProperty: property)
    }
    
    func remove(listener listener: AudioUnitPropertyListener, fromProperty property: AudioUnitPropertyID) {
        try! removePropertyListener(listener, fromProperty: property)
    }
    
}

// MARK: - AudioUnit callbacks

struct AudioUnitPropertyListener {
    
    typealias Callback = (audioUnit: AudioUnit, property: AudioUnitPropertyID) -> Void
    
    private let proc: AudioUnitPropertyListenerProc
    private let procInput: UnsafeMutablePointer<Callback>
    
    init(_ callback: Callback) {
        self.proc = { (inRefCon, inUnit, inID, inScope, inElement) in
            UnsafeMutablePointer<Callback>(inRefCon).memory(audioUnit: inUnit, property: inID)
        }
        
        self.procInput = UnsafeMutablePointer<Callback>.alloc(strideof(Callback))
        self.procInput.initialize(callback)
    }
    
}

// MARK: - AudioUnit function wrappers

private extension AudioUnit {
    
    func getPropertyInfo(propertyID: AudioUnitPropertyID) throws -> (dataSize: UInt32, writable: Bool) {
        var dataSize: UInt32 = 0
        var writable: DarwinBoolean = false
        
        try AudioUnitGetPropertyInfo(self, propertyID, kAudioUnitScope_Global, 0, &dataSize, &writable).check()
        
        return (dataSize: dataSize, writable: Bool(writable))
    }
    
    func getProperty<T>(propertyID: AudioUnitPropertyID, dataSize: UInt32) throws -> T {
        var dataSize = dataSize
        var data = UnsafeMutablePointer<T>.alloc(Int(dataSize))
        defer {
            data.dealloc(Int(dataSize))
        }
        
        try AudioUnitGetProperty(self, propertyID, kAudioUnitScope_Global, 0, data, &dataSize).check()
        
        return data.memory
    }
    
    func setProperty<T>(propertyID: AudioUnitPropertyID, dataSize: UInt32, data: T) throws {
        var data = data
        
        try AudioFileSetProperty(self, propertyID, dataSize, &data).check()
    }
    
    func addPropertyListener(listener: AudioUnitPropertyListener, toProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitAddPropertyListener(self, propertyID, listener.proc, listener.procInput).check()
    }
    
    func removePropertyListener(listener: AudioUnitPropertyListener, fromProperty propertyID: AudioUnitPropertyID) throws {
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
        
        let reversed = String(fourCharacterCode.characters.reverse())
        let bytes = (reversed as NSString).UTF8String
        let pointer = UnsafeMutablePointer<UInt32>(bytes)
        
        self = pointer.memory.littleEndian
    }
    
    var fourCharacterCode: String {
        var bytes = bigEndian
        return String(bytesNoCopy: &bytes, length: 4, encoding: NSASCIIStringEncoding, freeWhenDone: false)!
    }
    
}
