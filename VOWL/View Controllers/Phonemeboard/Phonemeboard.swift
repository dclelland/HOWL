//
//  Phonemeboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Phonemeboard {
    
    let phonemes = [
        Phoneme(withName: "a", frequencies: (700, 1220, 2600), bandwidths: (130,	 70, 160)),
        Phoneme(withName: "e", frequencies: (480, 1720, 2520), bandwidths: (70, 100, 200)),
        Phoneme(withName: "i", frequencies: (310, 2020, 2960), bandwidths: (45, 200, 400)),
        Phoneme(withName: "o", frequencies: (540, 1100, 2300), bandwidths: (80, 70, 70)),
        Phoneme(withName: "u", frequencies: (350, 1250, 2200), bandwidths: (65, 110, 140)),
        Phoneme(withName: "w", frequencies: (290, 610, 2150), bandwidths: (50, 80, 60)),
        Phoneme(withName: "schwa", frequencies: (440, 1320, 2450), bandwidths: (70, 100, 170))
    ]
    
}
