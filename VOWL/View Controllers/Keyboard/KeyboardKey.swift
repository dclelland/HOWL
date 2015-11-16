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
    var selected: Bool
    
    init(withPitch pitch: Int, selected: Bool) {
        self.pitch = pitch
        self.selected = selected
    }
}
