//
//  RoundedLabel.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable class RoundedLabel: UILabel {
    
    // MARK: - Properties
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
}
