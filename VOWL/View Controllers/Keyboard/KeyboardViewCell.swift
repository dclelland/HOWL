//
//  KeyboardViewCell.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardViewCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel?
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
}
