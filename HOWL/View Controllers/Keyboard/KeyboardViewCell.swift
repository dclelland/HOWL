//
//  KeyboardViewCell.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewCell: UICollectionViewCell {
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    override func awakeFromNib() {
        if let layer = layer as? CAShapeLayer {
            layer.strokeColor = UIColor.HOWL.blackColor().CGColor
            layer.lineWidth = CGFloat(M_SQRT2)
        }
    }
    
}
