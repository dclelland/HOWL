//
//  RoundedView.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UIView` subclass with added IBInspectable properties for setting corner radius and fill color. Overrides `drawRect:` to draw the rounded corners in a performant manner.
@IBDesignable public class RoundedView: UIView {
    
    // MARK: - Properties
    
    /// The view's corner radius. The radius given to the rounded rect created in `drawRect:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The color given to the rounded rect created in `drawRect:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = UIColor.clearColor()
        setNeedsDisplay()
    }
    
    // MARK: - Overrides
    
    override public func drawRect(rect: CGRect) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), fillColor?.CGColor)
        backgroundPath.fill()
        super.drawRect(rect)
    }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
}
