//
//  AudioUnit+Swift.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreAudio

struct PropertyListener {
    
    typealias Listener = @convention(c) (audioUnit: AudioUnit, property: AudioUnitPropertyID) -> Void
    
    private let inProc: AudioUnitPropertyListenerProc
    private let inProcUserData: UnsafeMutablePointer<Listener>
    
    init(_ listener: Listener) {
        self.inProc = { (inRefCon, inUnit, inID, inScope, inElement) in
            let listener = UnsafeMutablePointer<Listener>(inRefCon).memory
            listener(audioUnit: inUnit, property: inID)
        }
        
        self.inProcUserData = UnsafeMutablePointer<Listener>.alloc(sizeof(Listener))
        self.inProcUserData.initialize(listener)
    }

}

struct RenderNotify {
    
    // TODO: Revisit this
    typealias Callback = @convention(c) (actionFlags: AudioUnitRenderActionFlags, timestamp: AudioTimeStamp, numberOfFrames: UInt32, buffers: AudioBufferList) -> Void
    
    private let inProc: AURenderCallback
    private let inProcUserData: UnsafeMutablePointer<Callback>
    
    init (_ callback: Callback) {
        self.inProc = { (inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) in
            let callback = UnsafeMutablePointer<Callback>(inRefCon).memory
            callback(actionFlags: ioActionFlags.memory, timestamp: inTimeStamp.memory, numberOfFrames: inNumberFrames, buffers: ioData.memory)
            return noErr
        }
        
        self.inProcUserData = UnsafeMutablePointer<Callback>.alloc(sizeof(Callback))
        self.inProcUserData.initialize(callback)
    }
    
}

extension AudioUnit {
    
    func initialize() throws {
        try AudioUnitInitialize(self).verify()
    }
    
    func uninitialize() throws {
        try AudioUnitUninitialize(self).verify()
    }
    
    func getPropertyInfo(propertyID: AudioUnitPropertyID) throws -> (dataSize: UInt32, writable: Bool) {
        let outDataSize = UnsafeMutablePointer<UInt32>.alloc(sizeof(UInt32))
        let outWritable = UnsafeMutablePointer<DarwinBoolean>.alloc(sizeof(DarwinBoolean))
        
        try AudioUnitGetPropertyInfo(self, propertyID, kAudioUnitScope_Global, 0, outDataSize, outWritable).verify()
        
        return (outDataSize.memory, outWritable.memory.boolValue)
    }
    
    func getProperty<T>(propertyID: AudioUnitPropertyID) throws -> T {
        let outData = UnsafeMutablePointer<T>.alloc(sizeof(T))
        let ioDataSize = UnsafeMutablePointer<UInt32>.alloc(sizeof(UInt32))
        ioDataSize.initialize(UInt32(sizeof(T)))
        
        try AudioUnitGetProperty(self, propertyID, kAudioUnitScope_Global, 0, outData, ioDataSize).verify()
        
        return outData.memory
    }
    
    func setProperty<T>(propertyID: AudioUnitPropertyID, withValue value: T) throws {
        let inData = UnsafeMutablePointer<T>.alloc(sizeof(T))
        inData.initialize(value)
        let inDataSize = UInt32(sizeof(T))
        
        try AudioUnitSetProperty(self, propertyID, kAudioUnitScope_Global, 0, inData, inDataSize).verify()
    }
    
    func addPropertyListener(listener: PropertyListener, toProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitAddPropertyListener(self, propertyID, listener.inProc, listener.inProcUserData).verify()
    }
    
    func removePropertyListener(listener: PropertyListener, fromProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitRemovePropertyListenerWithUserData(self, propertyID, listener.inProc, listener.inProcUserData).verify()
    }
    
    func addRenderNotify(notify: RenderNotify) throws {
        try AudioUnitAddRenderNotify(self, notify.inProc, notify.inProcUserData).verify()
    }
    
    func removeRenderNotify(notify: RenderNotify) throws {
        try AudioUnitRemoveRenderNotify(self, notify.inProc, notify.inProcUserData).verify()
    }
    
    func getParameter(parameterID: AudioUnitParameterID) throws -> AudioUnitParameterValue {
        let outValue = UnsafeMutablePointer<AudioUnitParameterValue>.alloc(sizeof(AudioUnitParameterValue))
        
        try AudioUnitGetParameter(self, parameterID, kAudioUnitScope_Global, 0, outValue).verify()
        
        return outValue.memory
    }
    
    func setParameter(parameterID: AudioUnitParameterID, withValue value: AudioUnitParameterValue) throws {
        try AudioUnitSetParameter(self, parameterID, kAudioUnitScope_Global, 0, value, 0).verify()
    }
    
    func scheduleParameters(parameterEvents: [AudioUnitParameterEvent]) throws {
        try AudioUnitScheduleParameters(self, parameterEvents, UInt32(parameterEvents.count)).verify()
    }
    
    func render(actionFlags actionFlags: AudioUnitRenderActionFlags = [], timeStamp: AudioTimeStamp, outputBus: UInt32, numberFrames: UInt32, data: AudioBufferList) throws {
        let ioActionFlags = UnsafeMutablePointer<AudioUnitRenderActionFlags>.alloc(sizeof(AudioUnitRenderActionFlags))
        ioActionFlags.initialize(actionFlags)
        
        let inTimeStamp = UnsafeMutablePointer<AudioTimeStamp>.alloc(sizeof(AudioTimeStamp))
        inTimeStamp.initialize(timeStamp)
        
        let ioData = UnsafeMutablePointer<AudioBufferList>.alloc(sizeof(AudioBufferList))
        ioData.initialize(data)
        
        try AudioUnitRender(self, ioActionFlags, inTimeStamp, outputBus, numberFrames, ioData).verify()
    }
    
    func process(actionFlags actionFlags: AudioUnitRenderActionFlags = [], timeStamp: AudioTimeStamp, numberFrames: UInt32, data: AudioBufferList) throws {
        let ioActionFlags = UnsafeMutablePointer<AudioUnitRenderActionFlags>.alloc(sizeof(AudioUnitRenderActionFlags))
        ioActionFlags.initialize(actionFlags)
        
        let inTimeStamp = UnsafeMutablePointer<AudioTimeStamp>.alloc(sizeof(AudioTimeStamp))
        inTimeStamp.initialize(timeStamp)
        
        let ioData = UnsafeMutablePointer<AudioBufferList>.alloc(sizeof(AudioBufferList))
        ioData.initialize(data)
        
        try AudioUnitProcess(self, ioActionFlags, inTimeStamp, numberFrames, ioData).verify()
    }
    
    func processMultiple(actionFlags actionFlags: AudioUnitRenderActionFlags = [], timeStamp: AudioTimeStamp, numberFrames: UInt32, inputBufferLists: [AudioBufferList], outputBufferLists: [AudioBufferList]) throws {
        let ioActionFlags = UnsafeMutablePointer<AudioUnitRenderActionFlags>.alloc(sizeof(AudioUnitRenderActionFlags))
        ioActionFlags.initialize(actionFlags)
        
        let inTimeStamp = UnsafeMutablePointer<AudioTimeStamp>.alloc(sizeof(AudioTimeStamp))
        inTimeStamp.initialize(timeStamp)
        
        let inInputBufferLists = UnsafeMutablePointer<UnsafePointer<AudioBufferList>>.alloc(sizeof(UnsafePointer<AudioBufferList>))
        inInputBufferLists.initialize(inputBufferLists)
        
        let ioOutputBufferLists = UnsafeMutablePointer<UnsafeMutablePointer<AudioBufferList>>.alloc(sizeof(UnsafeMutablePointer<AudioBufferList>))
        ioOutputBufferLists.initialize(outputBufferLists)
        
        try AudioUnitProcessMultiple(self, ioActionFlags, inTimeStamp, numberFrames, UInt32(inputBufferLists.count), inInputBufferLists, UInt32(outputBufferLists.count), ioOutputBufferLists)
    }
    
    func reset() throws {
        try AudioUnitReset(self, kAudioUnitScope_Global, 0).verify()
    }
    
    func publish() throws {
        
    }
    
    func getHostIcon() throws {
        
    }
    
}

extension AudioComponent {
    
    func getIcon() throws -> UIImage? {
        return nil
    }
    
}

private extension OSStatus {
    
    func verify() throws {
        if self != noErr {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: nil)
        }
    }
    
}
