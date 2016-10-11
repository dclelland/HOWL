//
//  Pitch.swift
//  HOWL
//
//  Created by Daniel Clelland on 22/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

struct Pitch {
    
    let number: Int
    
    init(number: Int) {
        self.number = number
    }
    
    // MARK: Helpers
    
    enum Note: Int {
        case c = 0
        case cSharp = 1
        case d = 2
        case dSharp = 3
        case e = 4
        case f = 5
        case fSharp = 6
        case g = 7
        case gSharp = 8
        case a = 9
        case aSharp = 10
        case b = 11
    }
    
    var note: Note {
        let mod = number % 12
        if (mod < 0) {
            return Note(rawValue: 12 + mod)!
        } else {
            return Note(rawValue: mod)!
        }
    }
    
    var octave: Int {
        return number / 12 - 1
    }
    
    var frequency: Float {
        return pow(2.0, Float(number - 69) / 12.0) * 440.0
    }
    
}

// MARK: - Equatable

extension Pitch: Equatable {}

func ==(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.number == rhs.number
}

// MARK: - Comparable

extension Pitch: Comparable {}

func <(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.number < rhs.number
}

// MARK: - IntegerLiteralConvertible

extension Pitch: ExpressibleByIntegerLiteral {
    
    init(integerLiteral: Int) {
        self.init(number: integerLiteral)
    }
    
}

// MARK: - CustomStringConvertible

extension Pitch: CustomStringConvertible {
    
    var description: String {
        return note.description + String(octave)
    }
    
}

extension Pitch.Note: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .c: return "C"
        case .cSharp: return "C#"
        case .d: return "D"
        case .dSharp: return "D#"
        case .e: return "E"
        case .f: return "F"
        case .fSharp: return "F#"
        case .g: return "G"
        case .gSharp: return "G#"
        case .a: return "A"
        case .aSharp: return "A#"
        case .b: return "B"
        }
    }
    
}
