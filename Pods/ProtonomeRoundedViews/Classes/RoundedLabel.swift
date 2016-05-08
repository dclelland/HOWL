//
//  RoundedLabel.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UILabel` subclass with added IBInspectable properties for setting corner radius and fill color. Overrides `drawTextInRect:` to draw the rounded corners in a performant manner.
@IBDesignable public class RoundedLabel: UILabel {
    
    // MARK: - Properties
    
    /// The label's corner radius. The radius given to the rounded rect created in `drawTextInRect:`.
    /// If this is ever set, the label's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The label's fill color. The color given to the rounded rect created in `drawTextInRect:`.
    /// If this is ever set, the label's `backgroundColor` will be updated with `UIColor.clearColor()`.
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
    
    override public func drawTextInRect(rect: CGRect) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), fillColor?.CGColor)
        backgroundPath.fill()
        super.drawTextInRect(rect)
    }
    
    // MARK: - Private getters

    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
}
