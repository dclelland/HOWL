//
//  KeyboardKey.swift
//  VOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardKey {
    var pitch: Int
    var location: CGPoint
    var value: Float
    
    init(withPitch pitch: Int, location: CGPoint, value: Float) {
        self.pitch = pitch
        self.location = location
        self.value = value
    }
}
