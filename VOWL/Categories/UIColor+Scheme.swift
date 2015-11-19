//
//  UIColor+Scheme.swift
//  VOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

extension UIColor {
    
    private static let minimumGreyBrightness : CGFloat = 0.2
    private static let mediumGreyBrightness : CGFloat = 0.3
    private static let maximumGreyBrightness : CGFloat = 0.4
    
    private static let minimumColorBrightness : CGFloat = 0.5
    private static let mediumColorBrightness : CGFloat = 0.75
    private static let maximumColorBrightness : CGFloat = 1.0
    
    private static let minimumColorSaturation : CGFloat = 0.5
    private static let mediumColorSaturation : CGFloat = 0.625
    private static let maximumColorSaturation : CGFloat = 0.75
    
    // MARK: - VOWL Greyscale
    
    static func vowl_blackColor() -> UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    static func vowl_darkGreyColor() -> UIColor {
        return UIColor(white: minimumGreyBrightness, alpha: 1.0)
    }
    
    static func vowl_mediumGreyColor() -> UIColor {
        return UIColor(white: mediumGreyBrightness, alpha: 1.0)
    }
    
    static func vowl_lightGreyColor() -> UIColor {
        return UIColor(white: maximumGreyBrightness, alpha: 1.0)
    }
    
    static func vowl_whiteColor() -> UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    // MARK: - VOWL Color
    
    static func vowl_darkColor(withHue hue: CGFloat) -> UIColor {
        return UIColor(hue: hue, saturation: minimumColorSaturation, brightness: minimumColorBrightness, alpha: 1.0)
    }
    
    static func vowl_mediumColor(withHue hue: CGFloat) -> UIColor {
        return UIColor(hue: hue, saturation: mediumColorSaturation, brightness: mediumColorBrightness, alpha: 1.0)
    }
    
    static func vowl_lightColor(withHue hue: CGFloat) -> UIColor {
        return UIColor(hue: hue, saturation: maximumColorSaturation, brightness: maximumColorBrightness, alpha: 1.0)
    }

}
