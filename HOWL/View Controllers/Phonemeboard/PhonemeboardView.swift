//
//  PhonemeboardView.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import AudioKit

enum PhonemeboardViewState {
    case Normal
    case Highlighted
    case Selected
}

class PhonemeboardView: AKPlotView {
    
    var state: PhonemeboardViewState = .Normal
    
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    
    private var csound: CsoundObj?
    
    private var data = NSData()
    private var samples = [Float]() {
        didSet { updateUI() }
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
    
    // MARK: - Plot view
    
    override func defaultValues() { }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let path = CGPathCreateMutable()
        
        let length = samples.count / 2
        
        for i in 0..<length {
            let sample = CGFloat(samples[i * 2])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) * (bounds.width / CGFloat(length - 1))
            let y = (safeSample + 0.5) * bounds.height
            
            if (i == 0) {
                CGPathMoveToPoint(path, nil, x, y)
            } else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        
        for i in (0..<length).reverse() {
            let sample = CGFloat(samples[i * 2 + 1])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) * (bounds.width / CGFloat(length - 1))
            let y = (-safeSample + 0.5) * bounds.height
            
            CGPathAddLineToPoint(path, nil, x, y)
        }
        
        if length > 0 {
            CGPathCloseSubpath(path)
        }
        
        return UIBezierPath(CGPath: path)
    }
    
    private var backgroundPathColor: UIColor {
        switch state {
        case .Normal:
            return UIColor.protonome_darkGreyColor()
        case .Highlighted:
            return UIColor.protonome_mediumColor(withHue: hue, saturation: saturation)
        case .Selected:
            return UIColor.protonome_darkColor(withHue: hue, saturation: saturation)
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue, saturation: saturation)
    }
    
}

// MARK: - Csound binding

extension PhonemeboardView: CsoundBinding {
    
    func setup(csoundObj: CsoundObj) {
        csound = csoundObj
    }
    
    func updateValuesFromCsound() {
        if let csound = csound {
            data = csound.getOutSamples()
            
            var samples = [Float](count: data.length / sizeof(Float), repeatedValue: 0)
            
            data.getBytes(&samples, length:data.length)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.samples = samples
            })
        }
    }
    
}
