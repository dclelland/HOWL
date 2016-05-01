//
//  RoundedView.swift
//  HOWL
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {
    
    // MARK: - Properties
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 { didSet { configure() } }
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
}
