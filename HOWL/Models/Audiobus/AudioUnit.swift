//
//  AudioUnit+Swift.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreAudio
import LVGFourCharCodes

struct PropertyListener {
    
    typealias Listener = @convention(c) (audioUnit: AudioUnit, property: AudioUnitPropertyID) -> Void
    
    private let inProc: AudioUnitPropertyListenerProc
    private let inProcUserData: UnsafeMutablePointer<Listener>
    
    init(_ listener: Listener) {
        self.inProc = { (inRefCon, inUnit, inID, inScope, inElement) in
            UnsafeMutablePointer<Listener>(inRefCon).memory(audioUnit: inUnit, property: inID)
        }
        
        self.inProcUserData = UnsafeMutablePointer<Listener>.alloc(strideof(Listener))
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
        
        self.inProcUserData = UnsafeMutablePointer<Callback>.alloc(strideof(Callback))
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
        var outDataSize: UInt32 = UInt32()
        var outWritable: DarwinBoolean = false
        
        try AudioUnitGetPropertyInfo(self, propertyID, kAudioUnitScope_Global, 0, &outDataSize, &outWritable).verify()
        
        return (outDataSize, outWritable.boolValue)
    }
    
    func getProperty<T>(propertyID: AudioUnitPropertyID) throws -> T {
        let outData: UnsafeMutablePointer<T> = UnsafeMutablePointer.alloc(strideof(T))
        var ioDataSize = UInt32(strideof(T))
        
        try AudioUnitGetProperty(self, propertyID, kAudioUnitScope_Global, 0, outData, &ioDataSize).verify()
        
        return outData.memory
    }
    
    func setProperty<T>(propertyID: AudioUnitPropertyID, withValue value: T) throws {
        var inData = value
        let inDataSize = UInt32(strideof(T))
        
        try AudioUnitSetProperty(self, propertyID, kAudioUnitScope_Global, 0, &inData, inDataSize).verify()
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
        var outValue: AudioUnitParameterValue = AudioUnitParameterValue()
        try AudioUnitGetParameter(self, parameterID, kAudioUnitScope_Global, 0, &outValue).verify()
        return outValue
    }
    
    func setParameter(parameterID: AudioUnitParameterID, withValue value: AudioUnitParameterValue) throws {
        try AudioUnitSetParameter(self, parameterID, kAudioUnitScope_Global, 0, value, 0).verify()
    }
    
    func scheduleParameters(parameterEvents: [AudioUnitParameterEvent]) throws {
        let inNumParamEvents = UInt32(parameterEvents.count)
        try AudioUnitScheduleParameters(self, parameterEvents, inNumParamEvents).verify()
    }
    
//    func render(actionFlags actionFlags: AudioUnitRenderActionFlags = [], timeStamp: AudioTimeStamp, outputBus: UInt32, numberFrames: UInt32, data: AudioBufferList) throws {
//        var ioActionFlags = actionFlags
//        var inTimeStamp = timeStamp
//        var ioData = data
//        
//        try AudioUnitRender(self, &ioActionFlags, &inTimeStamp, outputBus, numberFrames, &ioData).verify()
//    }
//    
//    func process(inout actionFlags ioActionFlags: AudioUnitRenderActionFlags, inout timeStamp inTimeStamp: AudioTimeStamp, numberFrames inNumberFrames: UInt32, inout data ioData: AudioBufferList) throws {
//        try AudioUnitProcess(self, &ioActionFlags, &inTimeStamp, inNumberFrames, &ioData).verify()
//    }
//    
//    func processMultiple(inout actionFlags ioActionFlags: AudioUnitRenderActionFlags, inout timeStamp inTimeStamp: AudioTimeStamp, numberFrames inNumberFrames: UInt32, inout inputBufferLists inInputBufferLists: [AudioBufferList], inout outputBufferLists ioOutputBufferLists: [AudioBufferList]) throws {
//        let inNumberInputBufferLists = UInt32(inInputBufferLists.count)
//        let inNumberOutputBufferLists = UInt32(ioOutputBufferLists.count)
//        
//        AudioUnitProcessMultiple(self, &ioActionFlags, &inTimeStamp, inNumberFrames, inNumberInputBufferLists, &inInputBufferLists, inNumberOutputBufferLists, &ioOutputBufferLists)
//    }
    
    func reset() throws {
        try AudioUnitReset(self, kAudioUnitScope_Global, 0).verify()
    }
    
//    func publish(inout withDescription description: AudioComponentDescription, name: String, version: UInt32) throws {
//        try AudioOutputUnitPublish(&description, name, version, self).verify()
//    }
    
    func getHostIcon(withPointSize pointSize: Float) -> UIImage? {
        return AudioOutputUnitGetHostIcon(self, pointSize)
    }
    
}

extension AudioUnit {
    
    var parameters: [AudioUnitParameterInfo] {
        //  Get number of parameters in this unit (size in bytes really):
        var size: UInt32 = 0
        var propertyBool = DarwinBoolean(true)

        AudioUnitGetPropertyInfo(
            self,
            kAudioUnitProperty_ParameterList,
            kAudioUnitScope_Global,
            0,
            &size,
            &propertyBool)
        let numParams = Int(size)/sizeof(AudioUnitParameterID)
        var parameterIDs = [AudioUnitParameterID](count: Int(numParams), repeatedValue: 0)
        AudioUnitGetProperty(
            self,
            kAudioUnitProperty_ParameterList,
            kAudioUnitScope_Global,
            0,
            &parameterIDs,
            &size)
        var paramInfo = AudioUnitParameterInfo()
        var outParams = [AudioUnitParameterInfo]()
        var parameterInfoSize: UInt32 = UInt32(sizeof(AudioUnitParameterInfo))
        for paramID in parameterIDs {
            AudioUnitGetProperty(
                self,
                kAudioUnitProperty_ParameterInfo,
                kAudioUnitScope_Global,
                paramID,
                &paramInfo,
                &parameterInfoSize)
            outParams.append(paramInfo)
            print(paramID)
            print("Paramer name :\(paramInfo.cfNameString?.takeUnretainedValue()) | " +
                "Min:\(paramInfo.minValue) | " +
                "Max:\(paramInfo.maxValue) | " +
                "Default: \(paramInfo.defaultValue)")
        }
        return outParams
    }
}

extension AudioComponent {
    
    func getIcon(withPointSize pointSize: Float) -> UIImage? {
        return AudioComponentGetIcon(self, pointSize)
    }
    
}

private extension OSStatus {
    
    func verify() throws {
        if self != noErr {
            var userInfo = [NSObject: AnyObject]()
            userInfo["code"] = codeString
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: userInfo)
        }
    }
    
}
