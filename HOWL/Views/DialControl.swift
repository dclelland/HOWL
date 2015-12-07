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

@IBDesignable class DialControl: UIControl {
    
    // MARK: - Constants
    
    private let dialRadius = 0.375
    
    private let minimumAngle = 45.degrees
    private let maximumAngle = 315.degrees
    
    private let minimumDeadZone = 2.degrees
    private let maximumDeadZone = 358.degrees
    
    // MARK: - Properties
    
    @IBInspectable var title: String? { didSet { titleLabel.text = titleText } }
    @IBInspectable var suffix: String? { didSet { valueLabel.text = valueText } }
    
    @IBInspectable var value: Double = 0.0 {
        didSet {
            valueLabel.text = valueText
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    @IBInspectable var minimumValue: Double = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var maximumValue: Double = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var decimalPoints: Int = 1 { didSet { valueLabel.text = valueText } }
    
    @IBInspectable var logarithmic: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable var staircase: Bool = false { didSet { setNeedsDisplay() } }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        setupSubviews()
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
    
    // MARK: - Layout
    
    private func setupSubviews() {
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
        super.touchesBegan(touches, withEvent: event)
        
        touch = touches.first
        selected = true
        
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        touch = nil
        selected = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        touch = nil
        selected = false
    }
    
    // MARK: - Private getters (values)
    
    private var touch: UITouch?
    
    private var percentage: Double {
        set {
            value = newValue.lerp(min: minimumValue, max: maximumValue)
        }
        get {
            return value.ilerp(min: minimumValue, max: maximumValue)
        }
    }
    
    private func percentageForLocation(location: CGPoint) -> Double {
        let center = valueLabel.center
        let radius = min(valueLabel.frame.height, valueLabel.frame.width) * CGFloat(dialRadius)
        
        let distance = hypot(location.y - center.y, location.x - center.x)
        let angle = atan2(location.y - center.y, location.x - center.x)
        
        if distance < radius {
            return self.percentage
        }
        
        let scaledAngle = fmod(Double(angle) + 270.degrees, 360.degrees)
        
        if scaledAngle < minimumDeadZone || scaledAngle > maximumDeadZone {
            return self.percentage
        }
        
        return scaledAngle.ilerp(min: minimumAngle, max: maximumAngle).clamp(min: 0.0, max: 1.0)
    }
    
    // MARK: - Private getters (text)
    
    private var titleText: String? {
        return title
    }
    
    private var valueText: String? {
        let valueText = NSString(format: "%.\(decimalPoints)f", value) as String
        
        return suffix != nil ? valueText + suffix! : valueText
    }
    
    // MARK: - Private getters (drawing)
    
    private var hue: CGFloat {
        return CGFloat(lerp(percentage, min: 215.0, max: 0.0) / 360.0)
        
    }
    
    private var backgroundPathColor: UIColor {
        if (self.highlighted || self.selected) {
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
        let radius = min(valueLabel.frame.height, valueLabel.frame.width) * CGFloat(dialRadius)
        let angle = percentage.lerp(min: minimumAngle, max: maximumAngle)
        
        let pointerA = CGPoint(x: 0.0, y: 0.0)
        let pointerB = CGPoint(x: 0.0, y: 0.0)
        let pointerC = CGPoint(x: 0.0, y: 0.0)
        
        return UIBezierPath.makePath { make in
            make.oval(at: center, radius: radius)
            make.move(pointerA).move(pointerB).move(pointerC).close()
        }
        
        
//        CGFloat percentage = [self.instrumentProperty percentageForValue:value];
//        
//        CGPoint center = self.valueLabel.center;
//        CGFloat radius = fmin(CGRectGetWidth(self.valueLabel.bounds), CGRectGetHeight(self.valueLabel.bounds)) * GSDialControlRadius;
//        
//        CGFloat pointerAngle = GSLerp(percentage, GSDialControlMinDegrees, GSDialControlMaxDegrees);
//        
//        CGPoint pointerA = CGPointRotatedAroundPoint(CGPointMake(center.x, center.y + radius * 0.75), center, pointerAngle - 45.0);
//        CGPoint pointerB = CGPointRotatedAroundPoint(CGPointMake(center.x, center.y + radius * 1.25), center, pointerAngle);
//        CGPoint pointerC = CGPointRotatedAroundPoint(CGPointMake(center.x, center.y + radius * 0.75), center, pointerAngle + 45.0);
    }
    
}
