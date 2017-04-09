//
//  UIFont+Protonome.swift
//  HOWL
//
//  Created by Daniel Clelland on 09/03/17.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

// MARK: - Font scheme

/// Font helpers used throughout the `ProtonomeAudioKitControls` module.
public extension UIFont {
    
    // MARK: - Fonts
    
    /// Basic font type
    public static var protonomeFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return protonomeFont(withSize: 12.0)
        case .phone:
            return protonomeFont(withSize: 10.0)
        default:
            let size = UIFont.preferredFont(forTextStyle: .body).pointSize
            return protonomeFont(withSize: size)
        }
    }
    
    /// Generic font type
    public static func protonomeFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Futura-Medium", size: size)!
    }
    

}
