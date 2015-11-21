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
        Phoneme(withName: "a", location: CGPointMake(0.5, 0.0), frequencies: (700, 1220, 2600, 3300, 3750), bandwidths: (130, 70, 160, 250, 200)),
        Phoneme(withName: "e", location: CGPointMake(0.0, 0.333), frequencies: (480, 1720, 2520, 3300, 3750), bandwidths: (70, 100, 200, 250, 200)),
        Phoneme(withName: "i", location: CGPointMake(0.0, 0.667), frequencies: (310, 2020, 2960, 3300, 3750), bandwidths: (45, 200, 400, 250, 200)),
        Phoneme(withName: "o", location: CGPointMake(1.0, 0.333), frequencies: (540, 1100, 2300, 3300, 3750), bandwidths: (80, 70, 70, 250, 200)),
        Phoneme(withName: "u", location: CGPointMake(1.0, 0.667), frequencies: (350, 1250, 2200, 3300, 3750), bandwidths: (65, 110, 140, 250, 200)),
        Phoneme(withName: "w", location: CGPointMake(0.5, 1.0), frequencies: (290, 610, 2150, 3300, 3750), bandwidths: (50, 80, 60, 250, 200))
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
        let phonemeProximities = self.phonemes.map { (phoneme) -> (Phoneme, Float) in
            let distance = hypot(Float(location.x - phoneme.location.x), Float(location.y - phoneme.location.y))
            let proximity = pow((distance + 1), -4.0)
            
            return (phoneme, proximity)
        }
        
        let sum = phonemeProximities.reduce(0.0) { (sum, phonemeProximity) -> Float in
            let (_, proximity) = phonemeProximity
            
            return sum + proximity
        }
        
        let (frequencies, bandwidths) = phonemeProximities.reduce(((0.0, 0.0, 0.0, 0.0, 0.0), (0.0, 0.0, 0.0, 0.0, 0.0))) { (parameters, phonemeProximity) -> (Phoneme.Frequencies, Phoneme.Bandwidths) in
            let (frequencies, bandwidths) = parameters
            let (phoneme, proximity) = phonemeProximity
            
            let weighting = proximity / sum
            
            let weightedPhonemeFrequencies = (
                phoneme.frequencies.0 * weighting,
                phoneme.frequencies.1 * weighting,
                phoneme.frequencies.2 * weighting,
                phoneme.frequencies.3 * weighting,
                phoneme.frequencies.4 * weighting
            )
            
            let weightedPhonemeBandwidths = (
                phoneme.bandwidths.0 * weighting,
                phoneme.bandwidths.1 * weighting,
                phoneme.bandwidths.2 * weighting,
                phoneme.bandwidths.3 * weighting,
                phoneme.bandwidths.4 * weighting
            )
            
            let weightedFrequencies = (
                frequencies.0 + weightedPhonemeFrequencies.0,
                frequencies.1 + weightedPhonemeFrequencies.1,
                frequencies.2 + weightedPhonemeFrequencies.2,
                frequencies.3 + weightedPhonemeFrequencies.3,
                frequencies.4 + weightedPhonemeFrequencies.4
            )
            
            let weightedBandwidths = (
                bandwidths.0 + weightedPhonemeBandwidths.0,
                bandwidths.1 + weightedPhonemeBandwidths.1,
                bandwidths.2 + weightedPhonemeBandwidths.2,
                bandwidths.3 + weightedPhonemeBandwidths.3,
                bandwidths.4 + weightedPhonemeBandwidths.4
            )
            
            return (weightedFrequencies, weightedBandwidths)
        }
        
        return Phoneme.init(location: location, frequencies: frequencies, bandwidths: bandwidths)
    }
    
}
