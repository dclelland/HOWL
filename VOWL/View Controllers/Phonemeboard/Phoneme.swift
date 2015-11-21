//
//  Phoneme.swift
//  VOWL
//
//  Created by Daniel Clelland on 21/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phoneme {
    
    typealias Frequencies = (Float, Float, Float)
    typealias Bandwidths = (Float, Float, Float)
    
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
    
}
