//
//  Phonemeboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phonemeboard {
    
    private let phonemes = [
        Phoneme(withName: "a", location: CGPointMake(0.5, 0.0), frequencies: (700, 1220, 2600), bandwidths: (130, 70, 160)),
        Phoneme(withName: "e", location: CGPointMake(0.0, 0.333), frequencies: (480, 1720, 2520), bandwidths: (70, 100, 200)),
        Phoneme(withName: "i", location: CGPointMake(0.0, 0.667), frequencies: (310, 2020, 2960), bandwidths: (45, 200, 400)),
        Phoneme(withName: "o", location: CGPointMake(1.0, 0.333), frequencies: (540, 1100, 2300), bandwidths: (80, 70, 70)),
        Phoneme(withName: "u", location: CGPointMake(1.0, 0.667), frequencies: (350, 1250, 2200), bandwidths: (65, 110, 140)),
        Phoneme(withName: "w", location: CGPointMake(0.5, 1.0), frequencies: (290, 610, 2150), bandwidths: (50, 80, 60))
    ]
    
    // MARK: - Counts
    
    func numberOfPhonemes() -> Int {
        return phonemes.count
    }
    
    // MARK: - Phonemes
    
    func phonemeAtIndex(index: Int) -> Phoneme? {
        return phonemes[index]
    }
    
    func phonemeAtLocation(location: CGPoint) -> Phoneme? {
        return Phoneme(location: location, frequencies: (700, 1220, 2600), bandwidths: (130, 70, 160))
    }
    
    // MARK:
    
}
