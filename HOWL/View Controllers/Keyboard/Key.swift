//
//  Key.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

struct KeyCoordinates {
    var left: Int
    var right: Int
}

extension KeyCoordinates: Equatable {}

func ==(lhs: KeyCoordinates, rhs: KeyCoordinates) -> Bool {
    return lhs.left == rhs.left && lhs.right == rhs.right
}

class Key {
    var pitch: Int
    var path: UIBezierPath
    var coordinates: KeyCoordinates
    
    init(withPitch pitch: Int, path: UIBezierPath, coordinates: KeyCoordinates) {
        self.pitch = pitch
        self.path = path
        self.coordinates = coordinates
    }
    
    var note: Int {
        if pitch > 0 {
            return pitch % 12
        } else {
            return 12 + pitch % 12
        }
    }
    
    var octave: Int {
        return pitch / 12 - 1
    }
    
    var frequency: Float {
        return pow(2, (Float(pitch) - 69) / 12) * 440
    }
    
    var name: String {
        return noteName + octaveName
    }
    
    // MARK: Private getters
    
    private var noteName: String {
        switch note {
        case 0: return "C"
        case 1: return "C#"
        case 2: return "D"
        case 3: return "D#"
        case 4: return "E"
        case 5: return "F"
        case 6: return "F#"
        case 7: return "G"
        case 8: return "G#"
        case 9: return "A"
        case 10: return "A#"
        case 11: return "B"
        default: return ""
        }
    }
    
    private var octaveName: String {
        return String(octave)
    }
}

extension Key: Equatable {}

func ==(lhs: Key, rhs: Key) -> Bool {
    return lhs.pitch == rhs.pitch && lhs.coordinates == rhs.coordinates
}
