//
//  RoundedButton.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 7/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UILabel` subclass with added IBInspectable properties for setting corner radius and fill color. Creates resizable images with cap insets to draw the rounded corners in a performant manner.
@IBDesignable public class RoundedButton: UIButton {
    
    /// The button's corner radius. The radius given to the resizable images with which the button calls `setBackgroundImage:forState:`.
    /// If this is ever set, the button's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is set to `nil`, the button falls back upon `fillColor` for the highlighted state.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var fillColorHighlighted: UIColor? {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The radius given to the resizable image with which the button calls `setBackgroundImage:forState:`.
    /// If this is set to `nil`, the button falls back upon `fillColor` for the selected state.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var fillColorSelected: UIColor? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = UIColor.clearColor()
        setBackgroundImage(backgroundImageNormal, forState: .Normal)
        setBackgroundImage(backgroundImageHighlighted, forState: .Highlighted)
        setBackgroundImage(backgroundImageHighlighted, forState: [.Highlighted, .Selected])
        setBackgroundImage(backgroundImageSelected, forState: .Selected)
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
    
    private static func resizableImage(withColor color: UIColor, andCornerRadius cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: cornerRadius * 2.0 + 1.0, height: cornerRadius * 2.0 + 1.0)
        let path = CGPathCreateWithRoundedRect(rect, cornerRadius, cornerRadius, nil)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddPath(context, path)
        CGContextFillPath(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image.resizableImageWithCapInsets(UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .Stretch)
    }
    
}
