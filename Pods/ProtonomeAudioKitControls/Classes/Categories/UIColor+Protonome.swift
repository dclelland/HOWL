//
//  UIColor+Protonome.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp

// MARK: - Color scheme

/// Color helpers used throughout the `ProtonomeAudioKitControls` module.
public extension UIColor {
    
    // MARK: - Colors
    
    /// A low brightness color used for non highlighted audio control backgrounds.
    public static func protonomeDark(hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.5),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.2, max: 0.5),
            alpha: 1.0
        )
    }
    
    /// A medium brightness color used for highlighted audio control backgrounds.
    public static func protonomeMedium(hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.625),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.25, max: 0.75),
            alpha: 1.0
        )
    }
    
    /// A high brightness color used for audio control foregrounds.
    public static func protonomeLight(hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.75),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.3, max: 1.0),
            alpha: 1.0
        )
    }
    
    // MARK: - Greyscale colors
    
    /// A default black color.
    public static var protonomeBlack: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    /// A default dark gray color.
    public static var protonomeDarkGray: UIColor {
        return UIColor(white: 0.2, alpha: 1.0)
    }
    
    /// A default medium gray color.
    public static var protonomeMediumGray: UIColor {
        return UIColor(white: 0.25, alpha: 1.0)
    }
    
    /// A default light gray color.
    public static var protonomeLightGray: UIColor {
        return UIColor(white: 0.3, alpha: 1.0)
    }
    
    /// A default white color.
    public static var protonomeWhite: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

}
