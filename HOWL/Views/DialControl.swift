//
//  DialControl.swift
//  HOWL
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable class DialControl: UIControl {
    
    @IBInspectable var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    @IBInspectable var value: Float = 0
    @IBInspectable var minimumValue: Float = 0
    @IBInspectable var maximumValue: Float = 1
    
    let titleLabel = UILabel()

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        CGContextAddPath(context, backgroundPath.CGPath)
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        CGContextAddPath(context, foregroundPath.CGPath)
        CGContextFillPath(context)
    }
    
    // MARK: - Private getters (values)
    
    // MARK: - Private getters (drawing)
    
    private var hue: CGFloat {
        return 0.0 // TODO: This
    }
    
    private var backgroundPathColor: UIColor {
        if (self.highlighted || self.selected) {
            return UIColor.HOWL.mediumColor(withHue: hue)
        } else {
            return UIColor.HOWL.darkColor(withHue: hue)
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.HOWL.lightColor(withHue: hue)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        return UIBezierPath() // TODO: This
    }
    
}
