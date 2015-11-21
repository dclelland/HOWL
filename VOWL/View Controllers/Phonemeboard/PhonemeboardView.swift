//
//  PhonemeboardView.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class PhonemeboardView: AKPlotView, CsoundBinding {
    
    private var csound: CsoundObj?
    
    private var sampleSize = Int(AKSettings.shared().samplesPerControlPeriod)
    private var sampleChannels = Int(AKSettings.shared().numberOfChannels)
    
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
        
        var s = CGFloat(0.0)
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        
        for i in 0..<self.sampleSize {
            s = CGFloat(self.samples[i] + self.samples[i * 2]) / 2.0
            
            if isnan(s) {
                s = 0.0
            }
            
            x = s * self.bounds.height
            y = CGFloat(i)
            
            if (i == 0) {
                CGPathMoveToPoint(path, nil, x, y)
            } else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        
//        for (int i = sz - 1; i >= 0; i--) {
//            s = samples[i * 2 + 1] / GSOutputPlotLimit;
//            
//            if (isnan(s)) {
//                s = 0.0;
//            }
//            
//            x = GSLerp(GSInverseLerp(i, 0.0, sz - 1.0), CGRectGetMinX(self.bounds), CGRectGetMaxX(self.bounds));
//            y = GSLerp(GSInverseLerp(s, -1.0, 1.0), CGRectGetMaxY(self.bounds), CGRectGetMinY(self.bounds));
//            
//            CGPathAddLineToPoint(path, nil, x, y);
//        }
        
        objc_sync_exit(self)
        
        CGPathCloseSubpath(path)
        
        return UIBezierPath(CGPath: path)
    }
    
    // MARK: - Colors
    
    private func backgroundPathColor() -> UIColor {
        return self.backgroundColor ?? UIColor.clearColor()
    }
    
    private func foregroundPathColor() -> UIColor {
        return UIColor.VOWL.blackColor()
    }
    
}
