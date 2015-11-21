//
//  UIColor+Scheme.swift
//  VOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct VOWL {
        static let minimumGreyBrightness : CGFloat = 0.2
        static let mediumGreyBrightness : CGFloat = 0.25
        static let maximumGreyBrightness : CGFloat = 0.3
        
        static let minimumColorBrightness : CGFloat = 0.5
        static let mediumColorBrightness : CGFloat = 0.75
        static let maximumColorBrightness : CGFloat = 1.0
        
        static let minimumColorSaturation : CGFloat = 0.5
        static let mediumColorSaturation : CGFloat = 0.625
        static let maximumColorSaturation : CGFloat = 0.75
        
        // MARK: - Greyscale
        
        static func blackColor() -> UIColor {
            return UIColor(white: 0.0, alpha: 1.0)
        }
        
        static func darkGreyColor() -> UIColor {
            return UIColor(white: minimumGreyBrightness, alpha: 1.0)
        }
        
        static func mediumGreyColor() -> UIColor {
            return UIColor(white: mediumGreyBrightness, alpha: 1.0)
        }
        
        static func lightGreyColor() -> UIColor {
            return UIColor(white: maximumGreyBrightness, alpha: 1.0)
        }
        
        static func whiteColor() -> UIColor {
            return UIColor(white: 1.0, alpha: 1.0)
        }
        
        // MARK: - Color
        
        static func darkColor(withHue hue: CGFloat) -> UIColor {
            return UIColor(hue: hue, saturation: minimumColorSaturation, brightness: minimumColorBrightness, alpha: 1.0)
        }
        
        static func mediumColor(withHue hue: CGFloat) -> UIColor {
            return UIColor(hue: hue, saturation: mediumColorSaturation, brightness: mediumColorBrightness, alpha: 1.0)
        }
        
        static func lightColor(withHue hue: CGFloat) -> UIColor {
            return UIColor(hue: hue, saturation: maximumColorSaturation, brightness: maximumColorBrightness, alpha: 1.0)
        }
        
    }

}
