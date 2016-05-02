//
//  ToolbarButton.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable class ToolbarButton: UIButton {
    
    @IBInspectable var hue: CGFloat = 0.0 { didSet { configureImages() } }
    @IBInspectable var cornerRadius: CGFloat = 0.0 { didSet { configureImages() } }
    
    // MARK: - Configuration
    
    private func configureImages() {
        backgroundColor = UIColor.clearColor()
        
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.darkColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Normal)
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Highlighted)
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.mediumColor(withHue: hue), andCornerRadius: cornerRadius), forState: [.Highlighted, .Selected])
        setBackgroundImage(UIImage.image(withColor: UIColor.HOWL.lightColor(withHue: hue), andCornerRadius: cornerRadius), forState: .Selected)
    }

}
