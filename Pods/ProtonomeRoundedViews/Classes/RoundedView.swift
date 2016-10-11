//
//  RoundedView.swift
//  ProtonomeRoundedViews
//
//  Created by Daniel Clelland on 1/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit

/// IBDesignable `UIView` subclass with added IBInspectable properties for setting corner radius and fill color. Overrides `drawRect:` to draw the rounded corners in a performant manner.
@IBDesignable open class RoundedView: UIView {
    
    // MARK: - Properties
    
    /// The view's corner radius. The radius given to the rounded rect created in `drawRect:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    
    /// The view's fill color. The color given to the rounded rect created in `drawRect:`.
    /// If this is ever set, the view's `backgroundColor` will be updated with `UIColor.clearColor()`.
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        setNeedsDisplay()
    }
    
    // MARK: - Overrides
    
    override open func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(), let fillColor = fillColor {
            context.setFillColor(fillColor.cgColor)
            backgroundPath.fill()
        }
        
        super.draw(rect)
    }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
}
