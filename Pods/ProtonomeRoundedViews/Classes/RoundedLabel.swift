//
//  RoundedLabel.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UILabel` subclass with added IBInspectable properties for setting corner radius and fill color. Overrides `drawTextInRect:` to draw the rounded corners in a performant manner.
@IBDesignable open class RoundedLabel: UILabel {
    
    // MARK: - Properties
    
    /// The label's corner radius. The radius given to the rounded rect created in `drawTextInRect:`.
    /// If this is ever set, the label's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The label's fill color. The color given to the rounded rect created in `drawTextInRect:`.
    /// If this is ever set, the label's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    /// The label's top text inset.
    @IBInspectable open var textInsetTop: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The label's left text inset.
    @IBInspectable open var textInsetLeft: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The label's bottom text inset.
    @IBInspectable open var textInsetBottom: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The label's right text inset.
    @IBInspectable open var textInsetRight: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        setNeedsDisplay()
    }
    
    // MARK: - Overrides
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds.inset(by: textInsets), limitedToNumberOfLines: numberOfLines)
        return rect.inset(by: textInsets.inverse)
    }
    
    override open func drawText(in rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(), let fillColor = fillColor {
            context.setFillColor(fillColor.cgColor)
            backgroundPath.fill()
        }
        
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    // MARK: - Private getters

    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var textInsets: UIEdgeInsets {
        return UIEdgeInsets(top: textInsetTop, left: textInsetLeft, bottom: textInsetBottom, right: textInsetRight)
    }
    
}

// MARK: - Private extensions

private extension UIEdgeInsets {
    
    var inverse: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    
}
