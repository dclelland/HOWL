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
        label.textColor = self.tintColor
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.tintColor
        return label
    }()

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
    
    // MARK: - Private getters (values)
    
    private var percentage: Double {
        set {
            value = newValue
        }
        get {
            return value
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
        return UIBezierPath.makePath { make in
            make.oval(at: center, radius: min(frame.height, frame.width) * 0.25)
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
//        
//        return [UIBezierPath makePath:^(DSLBezierPathMaker *make) {
//            make.ovalAt(center, radius);
//            make.path([UIBezierPath makePath:^(DSLBezierPathMaker *make) {
//            make.moveTo(pointerA).lineTo(pointerB).lineTo(pointerC).close();
//            }]);
//            }];
    }
    
}
