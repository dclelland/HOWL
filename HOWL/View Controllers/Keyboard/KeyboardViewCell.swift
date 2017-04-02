//
//  KeyboardViewCell.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewCell: UICollectionViewCell {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func awakeFromNib() {
        if let layer = layer as? CAShapeLayer {
            layer.strokeColor = UIColor.protonomeBlack.cgColor
            layer.lineWidth = CGFloat(2.squareRoot())
        }
    }
    
}
