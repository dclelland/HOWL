//
//  Phonemeboard.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phonemeboard {
    
    private let soprano = [
        Phoneme(withName: "a", location: CGPoint(x: 0.5, y: 0.0), frequencies: (800, 1150, 2900, 3900, 4950), bandwidths: (80, 90, 120, 130, 140)),
        Phoneme(withName: "e", location: CGPoint(x: 0.0, y: 0.4), frequencies: (350, 2000, 2800, 3600, 4950), bandwidths: (60, 100, 120, 150, 200)),
        Phoneme(withName: "i", location: CGPoint(x: 0.2, y: 1.0), frequencies: (270, 2140, 2950, 3900, 4950), bandwidths: (60, 90, 100, 120, 120)),
        Phoneme(withName: "o", location: CGPoint(x: 1.0, y: 0.4), frequencies: (450, 800, 2830, 3800, 4950), bandwidths: (40, 80, 100, 120, 120)),
        Phoneme(withName: "u", location: CGPoint(x: 0.8, y: 1.0), frequencies: (325, 700, 2700, 3800, 4950), bandwidths: (50, 60, 170, 180, 200))
    ]
    
    private let alto = [
        Phoneme(withName: "a", location: CGPoint(x: 0.5, y: 0.0), frequencies: (800, 1150, 2800, 3500, 4950), bandwidths: (80, 90, 120, 130, 140)),
        Phoneme(withName: "e", location: CGPoint(x: 0.0, y: 0.4), frequencies: (400, 1600, 2700, 3300, 4950), bandwidths: (60, 80, 120, 150, 200)),
        Phoneme(withName: "i", location: CGPoint(x: 0.2, y: 1.0), frequencies: (350, 1700, 2700, 3700, 4950), bandwidths: (50, 100, 120, 150, 200)),
        Phoneme(withName: "o", location: CGPoint(x: 1.0, y: 0.4), frequencies: (450, 800, 2830, 3500, 4950), bandwidths: (70, 80, 100, 130, 135)),
        Phoneme(withName: "u", location: CGPoint(x: 0.8, y: 1.0), frequencies: (325, 700, 2530, 3500, 4950), bandwidths: (50, 60, 170, 180, 200))
    ]
    
    private let tenor = [
        Phoneme(withName: "a", location: CGPoint(x: 0.5, y: 0.0), frequencies: (650, 1080, 2650, 2900, 3250), bandwidths: (80, 90, 120, 130, 140)),
        Phoneme(withName: "e", location: CGPoint(x: 0.0, y: 0.4), frequencies: (400, 1700, 2600, 3200, 3580), bandwidths: (70, 80, 100, 120, 120)),
        Phoneme(withName: "i", location: CGPoint(x: 0.2, y: 1.0), frequencies: (290, 1870, 2800, 3250, 3540), bandwidths: (40, 90, 100, 120, 120)),
        Phoneme(withName: "o", location: CGPoint(x: 1.0, y: 0.4), frequencies: (400, 800, 2600, 2800, 3000), bandwidths: (70, 80, 100, 130, 135)),
        Phoneme(withName: "u", location: CGPoint(x: 0.8, y: 1.0), frequencies: (350, 600, 2700, 2900, 3300), bandwidths: (40, 60, 100, 120, 120))
    ]
    
    private let bass = [
        Phoneme(withName: "a", location: CGPoint(x: 0.5, y: 0.0), frequencies: (600, 1040, 2250, 2450, 2750), bandwidths: (60, 70, 110, 120, 130)),
        Phoneme(withName: "e", location: CGPoint(x: 0.0, y: 0.4), frequencies: (400, 1620, 2400, 2800, 3100), bandwidths: (40, 80, 100, 120, 120)),
        Phoneme(withName: "i", location: CGPoint(x: 0.2, y: 1.0), frequencies: (250, 1750, 2600, 3050, 3340), bandwidths: (60, 90, 100, 120, 120)),
        Phoneme(withName: "o", location: CGPoint(x: 1.0, y: 0.4), frequencies: (400, 750, 2400, 2600, 2900), bandwidths: (40, 80, 100, 120, 120)),
        Phoneme(withName: "u", location: CGPoint(x: 0.8, y: 1.0), frequencies: (350, 600, 2400, 2675, 2950), bandwidths: (40, 80, 100, 120, 120))
    ]
    
    // MARK: - Phonemes
    
    func sopranoPhonemeAtLocation(location: CGPoint) -> Phoneme {
        return Phoneme(withLocation: location, phonemes: soprano)
    }
    
    func altoPhonemeAtLocation(location: CGPoint) -> Phoneme {
        return Phoneme(withLocation: location, phonemes: alto)
    }
    
    func tenorPhonemeAtLocation(location: CGPoint) -> Phoneme {
        return Phoneme(withLocation: location, phonemes: tenor)
    }
    
    func bassPhonemeAtLocation(location: CGPoint) -> Phoneme {
        return Phoneme(withLocation: location, phonemes: bass)
    }
    
}
