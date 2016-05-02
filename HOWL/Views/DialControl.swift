//
//  DialControl.swift
//  HOWL
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Degrad
import Lerp

@IBDesignable class DialControl: RoundedControl {
    
    // MARK: - Constants
    
    private let dialRadius: Float = 0.375
    
    private let minimumAngle: Float = 45°
    private let maximumAngle: Float = 315°
    
    private let minimumDeadZone: Float = 2°
    private let maximumDeadZone: Float = 358°
    
    // MARK: - Properties
    
    @IBInspectable var title: String? { didSet { titleLabel.text = titleText } }
    @IBInspectable var suffix: String? { didSet { valueLabel.text = valueText } }
    
    @IBInspectable var value: Float = 0.0 {
        didSet {
            valueLabel.text = valueText
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    @IBInspectable var minimumValue: Float = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var maximumValue: Float = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var decimalPoints: Int = 1 { didSet { valueLabel.text = valueText } }
    
    @IBInspectable var logarithmic: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable var step: Bool = false { didSet { setNeedsDisplay() } }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 12.0)
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 12.0)
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    override var selected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        CGContextAddPath(context, backgroundPath.CGPath)
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        CGContextAddPath(context, foregroundPath.CGPath)
        CGContextFillPath(context)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.snp_updateConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        
        valueLabel.snp_updateConstraints { make in
            make.top.equalTo(self).offset(8.0)
            make.left.right.equalTo(self)
            make.bottom.equalTo(titleLabel.snp_top).offset(8.0)
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first
        selected = true
        
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touch = nil
        selected = false
        
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = nil
        selected = false
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    // MARK: - Private getters (text)
    
    private var titleText: String? {
        return title
    }
    
    private var valueText: String? {
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.positiveSuffix = suffix ?? ""
        numberFormatter.negativeSuffix = suffix ?? ""
        numberFormatter.minimumFractionDigits = decimalPoints
        numberFormatter.maximumFractionDigits = decimalPoints
        
        /* Needs check for negative zero values */
        
        return numberFormatter.stringFromNumber(value == -0 ? 0 : value)
    }
    
    // MARK: - Private getters (values)
    
    private var touch: UITouch?
    
    private var percentage: Float {
        set {
            switch scale {
            case .Linear:
                value = newValue.lerp(min: minimumValue, max: maximumValue)
            case .LinearStep:
                value = round(newValue.lerp(min: minimumValue, max: maximumValue))
            case .Logarithmic:
                value = pow(newValue, Float(M_E)).lerp(min: minimumValue, max: maximumValue)
            case .LogarithmicStep:
                value = round(pow(newValue, Float(M_E)).lerp(min: minimumValue, max: maximumValue))
            }
        }
        get {
            switch scale {
            case .Linear:
                return value.ilerp(min: minimumValue, max: maximumValue)
            case .LinearStep:
                return round(value).ilerp(min: minimumValue, max: maximumValue)
            case .Logarithmic:
                return pow(value.ilerp(min: minimumValue, max: maximumValue), 1.0 / Float(M_E))
            case .LogarithmicStep:
                return pow(round(value).ilerp(min: minimumValue, max: maximumValue), 1.0 / Float(M_E))
            }
        }
    }
    
    private func percentageForLocation(location: CGPoint) -> Float {
        let center = valueLabel.center
        let radius = dialRadius * Float(min(valueLabel.frame.height, valueLabel.frame.width))
        
        let distance = Float(hypot(location.y - center.y, location.x - center.x))
        let angle = Float(atan2(location.y - center.y, location.x - center.x))
        
        if distance < radius {
            return percentage
        }
        
        let scaledAngle = fmod(angle + 270°, 360°)
        
        if scaledAngle < minimumDeadZone || scaledAngle > maximumDeadZone {
            return percentage
        }
        
        return scaledAngle.ilerp(min: minimumAngle, max: maximumAngle).clamp(min: 0.0, max: 1.0)
    }
    
    private enum Scale {
        case Linear
        case LinearStep
        case Logarithmic
        case LogarithmicStep
    }
    
    private var scale: Scale {
        if logarithmic == false {
            if step == false {
                return .Linear
            } else {
                return .LinearStep
            }
        } else {
            if step == false {
                return .Logarithmic
            } else {
                return .LogarithmicStep
            }
        }
    }
    
    // MARK: - Private getters (drawing)
    
    private var hue: CGFloat {
        return CGFloat(lerp(percentage, min: 215.0, max: 0.0) / 360.0)
    }
    
    private var backgroundPathColor: UIColor {
        if (highlighted || selected) {
            return UIColor.HOWL.mediumColor(withHue: hue)
        } else {
            return UIColor.HOWL.darkColor(withHue: hue)
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.HOWL.lightColor(withHue: hue)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let center = valueLabel.center
        
        let radius = CGFloat(dialRadius) * min(valueLabel.frame.height, valueLabel.frame.width)
        let angle = CGFloat(percentage.lerp(min: minimumAngle, max: maximumAngle) + 90°)
        
        let pointerA = pol2rec(r: radius * 0.75, θ: angle - 45°)
        let pointerB = pol2rec(r: radius * 1.25, θ: angle)
        let pointerC = pol2rec(r: radius * 0.75, θ: angle + 45°)
        
        return UIBezierPath.makePath { make in
            make.oval(at: center, radius: radius)
            make.move(x: center.x + pointerA.x, y: center.y + pointerA.y)
            make.line(x: center.x + pointerB.x, y: center.y + pointerB.y)
            make.line(x: center.x + pointerC.x, y: center.y + pointerC.y)
            make.close()
        }
    }
    
}
