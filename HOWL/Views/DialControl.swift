//
//  DialControl.swift
//  HOWL
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Lerp

@IBDesignable class DialControl: UIControl {
    
    @IBInspectable var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    @IBInspectable var value: Double = 0
    @IBInspectable var minimumValue: Double = 0
    @IBInspectable var maximumValue: Double = 1
    
    enum Scale: String {
        case Linear = "Linear"
        case Logarithmic = "Logarithmic"
        case Staircase = "Staircase"
    }
    
    var scale: Scale = .Linear
    
    @IBInspectable var scaleName: String {
        set {
            if let newScale = Scale(rawValue: newValue) {
                scale = newScale
            }
        }
        get {
            return scale.rawValue
        }
    }
    
    enum Unit: String {
        case Number = "Number"
        case Integer = "Integer"
        case Percentage = "Percentage"
        case Frequency = "Frequency"
    }
    
    var unit: Unit = .Number
    
    @IBInspectable var unitName: String {
        set {
            if let newUnit = Unit(rawValue: newValue) {
                unit = newUnit
            }
        }
        get {
            return unit.rawValue
        }
    }
    
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
    
    // MARK: - Layout
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.snp_updateConstraints { make in
            make.edges.equalTo(self)
        }
        
        valueLabel.snp_updateConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    // MARK: - Private getters (values)
    
    private var percentage: Double {
        set {
            value = lerp(newValue, min: minimumValue, max: maximumValue)
        }
        get {
            return ilerp(value, min: minimumValue, max: maximumValue)
        }
    }
    
    // MARK: - Private getters (drawing)
    
    private var hue: CGFloat {
        return CGFloat(lerp(percentage, min: 215, max: 0) / 360)
        
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
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(frame.height, frame.width) * 0.25
        let angle = lerp(percentage, min: M_PI / 4, max: 7 * M_PI / 4)
        
        let pointerA = CGPoint(x: 0, y: 0)
        let pointerB = CGPoint(x: 0, y: 0)
        let pointerC = CGPoint(x: 0, y: 0)
        
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
