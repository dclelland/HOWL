//
//  RoundedButton.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 7/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UILabel` subclass with added IBInspectable properties for setting corner radius and fill color. Creates resizable images with cap insets to draw the rounded corners in a performant manner.
@IBDesignable open class RoundedButton: UIButton {
    
    /// The button's corner radius. The radius given to the resizable images with which the button calls `setBackgroundImage:forState:`.
    /// If this is ever set, the button's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is set to `nil`, the button falls back upon `fillColor` for the highlighted state.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var fillColorHighlighted: UIColor? {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is set to `nil`, the button falls back upon `fillColor` for the selected state.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var fillColorSelected: UIColor? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        setBackgroundImage(backgroundImageNormal, for: .normal)
        setBackgroundImage(backgroundImageHighlighted, for: .highlighted)
        setBackgroundImage(backgroundImageHighlighted, for: [.highlighted, .selected])
        setBackgroundImage(backgroundImageSelected, for: .selected)
    }
    
    // MARK: - Private getters
    
    private var backgroundImageNormal: UIImage? {
        if let fillColor = fillColor {
            return UIImage.resizableImage(withColor: fillColor, andCornerRadius: cornerRadius)
        }
        return nil
    }
    
    private var backgroundImageHighlighted: UIImage? {
        if let fillColorHighlighted = fillColorHighlighted ?? fillColor {
            return UIImage.resizableImage(withColor: fillColorHighlighted, andCornerRadius: cornerRadius)
        }
        return nil
    }
    
    private var backgroundImageSelected: UIImage? {
        if let fillColorSelected = fillColorSelected ?? fillColor {
            return UIImage.resizableImage(withColor: fillColorSelected, andCornerRadius: cornerRadius)
        }
        return nil
    }

}

// MARK: - Private extensions

private extension UIImage {
    
    static func resizableImage(withColor color: UIColor, andCornerRadius cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: cornerRadius * 2.0 + 1.0, height: cornerRadius * 2.0 + 1.0)
        let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.addPath(path)
        context?.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .stretch)
    }
    
}
