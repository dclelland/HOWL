//
//  PhonemeboardView.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

enum PhonemeboardViewState {
    case Normal
    case Highlighted
    case Selected
}

class PhonemeboardView: AKPlotView, CsoundBinding {
    
    var state: PhonemeboardViewState = .Normal
    
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    
    private var csound: CsoundObj?
    
    private var samples = [Float]() {
        didSet {
            self.performSelectorOnMainThread("updateUI", withObject: nil, waitUntilDone: false)
        }
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, self.backgroundPathColor().CGColor)
        CGContextAddPath(context, self.backgroundPath().CGPath)
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, self.foregroundPathColor().CGColor)
        CGContextAddPath(context, self.foregroundPath().CGPath)
        CGContextFillPath(context)
    }
    
    // MARK: - Csound binding
    
    func setup(csoundObj: CsoundObj) {
        self.csound = csoundObj
    }
    
    func updateValuesFromCsound() {
        if let csound = self.csound {
            let data = csound.getOutSamples()
            let count = data.length / sizeof(Float)
            var samples = [Float](count: count, repeatedValue: 0)
            
            data.getBytes(&samples, length:count * sizeof(Float))
            
            self.samples = samples
        }
    }
    
    // MARK: - Plot view
    
    override func defaultValues() { }
    
    // MARK: - Paths
    
    private func backgroundPath() -> UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
    }
    
    private func foregroundPath() -> UIBezierPath {
        let path = CGPathCreateMutable()
        
        objc_sync_enter(self)
        
        let sz = self.samples.count / 2
        
        var i: Int
        
        var s = CGFloat(0.0)
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        
        for i = 0; i < sz; i++ {
            s = CGFloat(self.samples[i * 2])
            
            if isnan(s) {
                s = 0.0
            }
            
            x = CGFloat(i) * (self.bounds.width / CGFloat(sz - 1))
            y = (s + 0.5) * self.bounds.height
            
            if (i == 0) {
                CGPathMoveToPoint(path, nil, x, y)
            } else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        
        for i = sz - 1; i >= 0; i-- {
            s = CGFloat(self.samples[i * 2 + 1])
            
            if (isnan(s)) {
                s = 0.0
            }
            
            x = CGFloat(i) * (self.bounds.width / CGFloat(sz - 1))
            y = (-s + 0.5) * self.bounds.height
            
            CGPathAddLineToPoint(path, nil, x, y)
        }
        
        objc_sync_exit(self)
        
        CGPathCloseSubpath(path)
        
        return UIBezierPath(CGPath: path)
    }
    
    // MARK: - Colors
    
    private func backgroundPathColor() -> UIColor {
        switch self.state {
        case .Normal:
            return UIColor.VOWL.darkGreyColor()
        case .Highlighted:
            return UIColor.VOWL.mediumColor(withHue: self.hue, saturation: self.saturation)
        case .Selected:
            return UIColor.VOWL.darkColor(withHue: self.hue, saturation: self.saturation)
        }
    }
    
    private func foregroundPathColor() -> UIColor {
        return UIColor.VOWL.lightColor(withHue: self.hue, saturation: self.saturation)
    }
    
}
