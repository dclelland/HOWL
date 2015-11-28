//
//  Phoneme.swift
//  VOWL
//
//  Created by Daniel Clelland on 21/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phoneme {
    
    typealias Frequencies = (Float, Float, Float, Float, Float)
    typealias Bandwidths = (Float, Float, Float, Float, Float)
    
    let name: String?
    let location: CGPoint
    let frequencies: Frequencies
    let bandwidths: Bandwidths
    
    init(withName name: String? = nil, location: CGPoint, frequencies: Frequencies, bandwidths: Bandwidths) {
        self.name = name
        self.location = location
        self.frequencies = frequencies
        self.bandwidths = bandwidths
    }
    
    convenience init(withLocation location: CGPoint, phonemes: [Phoneme]) {
        let phonemeProximities = phonemes.map { (phoneme) -> (Phoneme, Float) in
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
        
        self.init(location: location, frequencies: frequencies, bandwidths: bandwidths)
    }
    
}
