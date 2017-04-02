//
//  AudioUnit+Properties.swift
//  Pods
//
//  Created by Daniel Clelland on 02/04/17.
//

import Foundation

// MARK: - Four character codes

extension UInt32 {
    
    /// Create a `UInt32` with a four character code. Will crash if the string is not four characters long.
    public init(fourCharacterCode: String) {
        assert(fourCharacterCode.characters.count == 4, "String should be four characters long")
        
        let reversed = String(fourCharacterCode.characters.reversed())
        let bytes = (reversed as NSString).utf8String
        let pointer = UnsafeRawPointer(bytes)!.assumingMemoryBound(to: UInt32.self)
        
        self = pointer.pointee.littleEndian
    }
    
    /// Converts the four character code back to a string.
    public var fourCharacterCode: String {
        var bytes = bigEndian
        return String(bytesNoCopy: &bytes, length: 4, encoding: .ascii, freeWhenDone: false)!
    }
    
}

// MARK: - Private methods

internal extension OSStatus {
    
    func check() throws {
        if self != noErr {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: nil)
        }
    }
    
}
