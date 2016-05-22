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
        case C = 0
        case CSharp = 1
        case D = 2
        case DSharp = 3
        case E = 4
        case F = 5
        case FSharp = 6
        case G = 7
        case GSharp = 8
        case A = 9
        case ASharp = 10
        case B = 11
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

extension Pitch: IntegerLiteralConvertible {
    
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
        case .C: return "C"
        case .CSharp: return "C#"
        case .D: return "D"
        case .DSharp: return "D#"
        case .E: return "E"
        case .F: return "F"
        case .FSharp: return "F#"
        case .G: return "G"
        case .GSharp: return "G#"
        case .A: return "A"
        case .ASharp: return "A#"
        case .B: return "B"
        }
    }
    
}
