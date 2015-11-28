//
//  UIImage+HOWL.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

// MARK: - Colored images

extension UIImage {
    
    static func image(withColor color: UIColor) -> UIImage {
        return image(withColor: color, andCornerRadius: 0.0)
    }
    
    static func image(withColor color: UIColor, andCornerRadius cornerRadius: CGFloat) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, cornerRadius * 2.0 + 1.0, cornerRadius * 2.0 + 1.0)
        let path = CGPathCreateWithRoundedRect(rect, cornerRadius, cornerRadius, nil)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddPath(context, path)
        CGContextFillPath(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image.resizableImageWithCapInsets(UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius), resizingMode: .Stretch)
    }
    
}
