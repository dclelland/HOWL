//
//  CGRect+Normalization.swift
//  VOWL
//
//  Created by Daniel Clelland on 21/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: - Normalization

extension CGRect {
    
    func normalizationTransform() -> CGAffineTransform {
        return CGAffineTransformInvert(denormalizationTransform())
    }
    
    func denormalizationTransform() -> CGAffineTransform {
        let scale = CGAffineTransformMakeScale(width, height)
        let translation = CGAffineTransformMakeTranslation(minX, minY)
        
        return CGAffineTransformConcat(scale, translation)
    }

}
