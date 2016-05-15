//
//  AudioPlot.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import AudioKit

/// IBDesignable `UIControl` subclass which draws the current CSound buffer as a waveform in `drawRect:`.
@IBDesignable public class AudioPlot: UIControl {
    
    // MARK: - Parameters
    
    // MARK: State
    
    @IBInspectable override public var selected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable override public var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Scale
    
    /// The factor by which the waveform is scaled vertically. Defaults to 1.0.
    @IBInspectable public var plotScale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Color
    
    /// The hue used to draw the background and waveform. Defaults to 0.0.
    @IBInspectable public var colorHue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The saturation used to draw the background and waveform. Defaults to 0.0.
    @IBInspectable public var colorSaturation: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Corner radius
    
    /// The control's corner radius. The radius given to the rounded rect created in `drawRect:`.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private vars
    
    private var csound: CsoundObj?
    
    private var data = NSData()
    
    private var samples = [Float]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    deinit {
        AKManager.removeBinding(self)
    }
    
    // MARK: - Overrides
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        var testSamples = [Float](count: 512, repeatedValue: 0.0)
        
        for index in testSamples.indices {
            testSamples[index] = sin(Float(index / 2) / 256.0 * Float(M_PI * 2.0))
        }
        
        samples = testSamples
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if (superview == nil) {
            AKManager.removeBinding(self)
        } else {
            AKManager.addBinding(self)
        }
    }
    
    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        foregroundPath.fill()
    }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let path = CGPathCreateMutable()
        
        let length = samples.count / 2
        
        for i in 0..<length {
            let sample = CGFloat(samples[i * 2])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) * (bounds.width / CGFloat(length - 1))
            let y = safeSample.lerp(min: 0.5, max: 0.5 + plotScale * 0.5) * bounds.height
            
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
            let y = safeSample.lerp(min: 0.5, max: 0.5 - plotScale * 0.5) * bounds.height
            
            CGPathAddLineToPoint(path, nil, x, y)
        }
        
        if length > 0 {
            CGPathCloseSubpath(path)
        }
        
        return UIBezierPath(CGPath: path)
    }
    
    private var backgroundPathColor: UIColor {
        switch (highlighted, selected) {
        case (true, _):
            return UIColor.protonome_mediumColor(withHue: colorHue, saturation: colorSaturation)
        case (_, true):
            return UIColor.protonome_darkColor(withHue: colorHue, saturation: colorSaturation)
        default:
            return UIColor.protonome_darkGrayColor()
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: colorHue, saturation: colorSaturation)
    }
    
}

extension AudioPlot: CsoundBinding {
    
    public func setup(csoundObj: CsoundObj) {
        csound = csoundObj
    }
    
    public func updateValuesFromCsound() {
        guard let csound = csound else {
            return
        }
        
        data = csound.getOutSamples()
        
        var samples = [Float](count: data.length / sizeof(Float), repeatedValue: 0.0)
        
        data.getBytes(&samples, length:data.length)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.samples = samples
        })
    }
    
}
