//
//  PhonemeboardView.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class PhonemeboardView: AKPlotView, CsoundBinding {
    
    var csound: CsoundObj?
    var samples: NSData? {
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
            self.samples = csound.getOutSamples()
        }
    }
    
    // MARK: - Plot view
    
    override func defaultValues() { }
    
    // MARK: - Paths
    
    private func backgroundPath() -> UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
    }
    
    private func foregroundPath() -> UIBezierPath {
        let diceRoll = CGFloat(arc4random_uniform(6) + 1)
        return UIBezierPath(roundedRect: CGRectMake(20.0 + diceRoll, 20.0, 100.0, 100.0), cornerRadius: 5.0)
    }
    
    // MARK: - Colors
    
    private func backgroundPathColor() -> UIColor {
        return self.backgroundColor ?? UIColor.clearColor()
    }
    
    private func foregroundPathColor() -> UIColor {
        return UIColor.VOWL.blackColor()
    }
    
    // MARK: - Samples
    
    private func sampleSize() -> Int {
        return Int(AKSettings.shared().numberOfChannels) * Int(AKSettings.shared().samplesPerControlPeriod)
    }
    
}
