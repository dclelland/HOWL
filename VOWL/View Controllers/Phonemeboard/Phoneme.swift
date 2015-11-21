//
//  Phoneme.swift
//  VOWL
//
//  Created by Daniel Clelland on 21/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phoneme {
    let name: String?
    let frequencies: (Float, Float, Float)
    let bandwidths: (Float, Float, Float)
    
    init(withName name: String? = nil, frequencies: (Float, Float, Float), bandwidths: (Float, Float, Float)) {
        self.name = name
        self.frequencies = frequencies
        self.bandwidths = bandwidths
    }
}
