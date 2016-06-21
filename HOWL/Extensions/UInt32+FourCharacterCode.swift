//
//  UInt32+FourCharacterCode.swift
//  HOWL
//
//  Created by Daniel Clelland on 21/06/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

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