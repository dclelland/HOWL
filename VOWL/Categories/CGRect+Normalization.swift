//
//  CGRect+Normalization.swift
//  VOWL
//
//  Created by Daniel Clelland on 21/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

extension CGRect {
    
    // MARK: - Normalization
    
    func normalizationTransform() -> CGAffineTransform {
        return CGAffineTransformInvert(self.denormalizationTransform())
    }
    
    func denormalizationTransform() -> CGAffineTransform {
        let scale = CGAffineTransformMakeScale(self.width, self.height)
        let translation = CGAffineTransformMakeTranslation(self.minX, self.minY)
        
        return CGAffineTransformConcat(scale, translation)
    }

}
