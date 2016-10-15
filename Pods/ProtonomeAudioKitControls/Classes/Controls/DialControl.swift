//
//  DialControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Degrad
import Lerp
import SnapKit

/// IBDesignable `AudioControl` subclass which draws a dial, which can be used to select a value radially, using the touch point's angle relative to the dial's center.
/// This way, the user can exert arbitrarily precise control over the dial, depending upon how far away their touch is from the dial.
@IBDesignable open class DialControl: AudioControl {
    
    // MARK: - Private constants
    
    private let dialRadius: Float = 0.375
    
    private let minimumAngle: Float = 45°
    private let maximumAngle: Float = 315°
    
    private let minimumDeadZone: Float = 2°
    private let maximumDeadZone: Float = 358°
    
    // MARK: - Views
    
    /// The control's value label. Displays the contents of `value`, as processed by the control's `formatter` object.
    /// The constraints created for this label respect the layout margins, so they may be used to customise the padding around the value label.
    /// The dial indicator is drawn centered on this label.
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .protonomeBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        valueLabel.text = formatter.string(for: value)
        valueLabel.font = font
    }
    
    override open func updateConstraints() {
        super.updateConstraints()
        
        addSubview(valueLabel)
        valueLabel.snp.updateConstraints { make in
            make.top.equalTo(snp.topMargin)
            make.left.equalTo(snp.leftMargin)
            make.right.equalTo(snp.rightMargin)
            make.bottom.equalTo(titleLabel.snp.top)
        }
    }
    
    // MARK: - Overrideables
    
    /**
     A method used to convert the current touch location into a useful ratio, in range `0.0...1.0`.
     If the touch is inside the dial's indicator, or if it falls inside the 4° dead zone at the base of the dial, it returns the current value. Otherwise, it takes the angle of the touch location relative to the center of the dial indicator, and calculates a ratio from that.
     
     - parameter location: The touch location.
     
     - returns: A ratio, in range `0.0...1.0`.
     */
    override open func ratio(for location: CGPoint) -> Float {
        let center = valueLabel.center
        let radius = dialRadius * Float(min(valueLabel.frame.height, valueLabel.frame.width))
        
        let distance = Float(hypot(location.y - center.y, location.x - center.x))
        let angle = Float(atan2(location.y - center.y, location.x - center.x))
        
        guard radius < distance else {
            return scale.ratio(for: value)
        }
        
        let scaledAngle = fmod(angle + 270°, 360°)
        
        guard (minimumDeadZone...maximumDeadZone).contains(scaledAngle) else {
            return scale.ratio(for: value)
        }
        
        return scaledAngle.ilerp(min: minimumAngle, max: maximumAngle).clamp(min: 0.0, max: 1.0)
    }
    
    /**
     A method used to convert a ratio, in range `0.0...1.0`, into a bezier path used for the dial control's indicator.
     This instance returns a circular path with additional indicator notch.
     
     - parameter ratio: A ratio, in range `0.0...1.0`.
     
     - returns: A bezier path used for the dial control's indicator.
     */
    override open func path(for ratio: Float) -> UIBezierPath {
        let center = valueLabel.center
        
        let radius = CGFloat(dialRadius) * min(valueLabel.frame.height, valueLabel.frame.width)
        let angle = CGFloat(ratio.lerp(min: minimumAngle, max: maximumAngle) + 90°)
        
        let pointerA = pol2rec(r: radius * 0.75, θ: angle - 45°)
        let pointerB = pol2rec(r: radius * 1.25, θ: angle)
        let pointerC = pol2rec(r: radius * 0.75, θ: angle + 45°)
        
        return UIBezierPath { path in
            path.add(.oval, center: center, radius: radius)
            path.add(.move, x: center.x + pointerA.x, y: center.y + pointerA.y)
            path.add(.line, x: center.x + pointerB.x, y: center.y + pointerB.y)
            path.add(.line, x: center.x + pointerC.x, y: center.y + pointerC.y)
            path.close()
        }
    }
    
}
