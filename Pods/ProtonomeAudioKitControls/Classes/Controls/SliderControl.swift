//
//  SliderControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp

/// IBDesignable `AudioControl` subclass which draws a slider, which can be used to select a value from a grid of values.
/// When the touch point is over the slider, its y position has a 1:1 ratio with the slider's value, but this decreases as the touch point moves further away from the slider.
/// This way, the user can exert arbitrarily precise control over the dial, depending upon how far away their touch is from the slider.
@IBDesignable public class SliderControl: AudioControl {
    
    // MARK: - Views
    
    /// The control's value label. Displays the contents of `value`, as processed by the control's `formatter` object.
    /// The constraints created for this label respect the layout margins, so they may be used to customise the padding around the value label.
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.protonome_blackColor()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        valueLabel.text = formatter.string(forValue: value)
        valueLabel.font = font
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(valueLabel)
        valueLabel.snp_updateConstraints { make in
            make.top.equalTo(self.snp_topMargin)
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.height.equalTo(valueLabel.snp_width).multipliedBy(0.75)
        }
    }
    
    // MARK: - Overrideables
    
    private var exitRatio: CGFloat = 0.0
    
    /**
     A method used to convert the current touch location into a useful ratio, in range `0.0...1.0`.
     If the touch is inside the slider, the calculation is a simple linear interpolation of the touch location's y position.
     However, if the touch exits the slider from either side, the granularity of the linear interpolation is increased by a factor of the touch location's x distance from the slider.
     
     - parameter location: The touch location.
     
     - returns: A ratio, in range `0.0...1.0`.
     */
    override public func ratio(forLocation location: CGPoint) -> Float {
        switch location.x {
        case (-.max)..<bounds.minX:
            let scale = bounds.minX - location.x
            let min = bounds.maxY + scale * exitRatio
            let max = bounds.minY - scale * (1.0 - exitRatio)
            let ratio = location.y.ilerp(min: min, max: max).clamp(min: 0.0, max: 1.0)
            return Float(ratio)
        case bounds.minX...bounds.maxX:
            let min = bounds.maxY
            let max = bounds.minY
            let ratio = location.y.ilerp(min: min, max: max).clamp(min: 0.0, max: 1.0)
            exitRatio = ratio
            return Float(ratio)
        default:
            let scale = location.x - bounds.maxX
            let min = bounds.maxY + scale * exitRatio
            let max = bounds.minY - scale * (1.0 - exitRatio)
            let ratio = location.y.ilerp(min: min, max: max)
            return Float(ratio).clamp(min: 0.0, max: 1.0)
        }
    }
    
    /**
     A method used to convert a ratio, in range `0.0...1.0`, into a bezier path used for the slider control's indicator.
     This instance returns a rect that progressively "fills up" the slider.
     
     - parameter ratio: A ratio, in range `0.0...1.0`.
     
     - returns: A bezier path used for the slider control's indicator.
     */
    override public func path(forRatio ratio: Float) -> UIBezierPath {
        let rect = CGRect(x: 0.0, y: 1.0 - CGFloat(ratio), width: 1.0, height: CGFloat(ratio))
        
        return UIBezierPath(rect: rect.lerp(rect: bounds))
    }
    
}
