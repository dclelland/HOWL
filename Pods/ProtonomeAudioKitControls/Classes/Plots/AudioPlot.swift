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
@IBDesignable open class AudioPlot: UIControl {
    
    // MARK: - Parameters
    
    // MARK: State
    
    @IBInspectable override open var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable override open var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Scale
    
    /// The factor by which the waveform is scaled vertically. Defaults to 1.0.
    @IBInspectable open var plotScale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Color
    
    /// The hue used to draw the background and waveform. Defaults to 0.0.
    @IBInspectable open var colorHue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The saturation used to draw the background and waveform. Defaults to 0.0.
    @IBInspectable open var colorSaturation: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Corner radius
    
    /// The control's corner radius. The radius given to the rounded rect created in `drawRect:`.
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private vars
    
    fileprivate var csound: CsoundObj?
    
    fileprivate var data = Data()
    
    fileprivate var samples = [Float]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    deinit {
        AKManager.removeBinding(self)
    }
    
    // MARK: - Overrides
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        var testSamples = [Float](repeating: 0.0, count: 512)
        
        for index in testSamples.indices {
            testSamples[index] = sin(Float(index / 2) / 256.0 * (2.0 * .pi))
        }
        
        samples = testSamples
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if (superview == nil) {
            AKManager.removeBinding(self)
        } else {
            AKManager.addBinding(self)
        }
    }
    
    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.clear(rect)
        
        context.setFillColor(backgroundPathColor.cgColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        context.setFillColor(foregroundPathColor.cgColor)
        foregroundPath.fill()
    }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let path = CGMutablePath()
        
        let length = samples.count / 2
        
        for i in 0..<length {
            let sample = CGFloat(samples[i * 2])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) / CGFloat(length - 1)
            let y = safeSample.lerp(min: 0.5, max: 0.5 + plotScale * 0.5)
            
            let location = CGPoint(x: x, y: y).lerp(rect: bounds)
            
            if (i == 0) {
                path.move(to: location)
            } else {
                path.addLine(to: location)
            }
        }
        
        for i in (0..<length).reversed() {
            let sample = CGFloat(samples[i * 2 + 1])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) / CGFloat(length - 1)
            let y = safeSample.lerp(min: 0.5, max: 0.5 - plotScale * 0.5)
            
            let location = CGPoint(x: x, y: y).lerp(rect: bounds)
            
            path.addLine(to: location)
        }
        
        if length > 0 {
            path.closeSubpath()
        }
        
        return UIBezierPath(cgPath: path)
    }
    
    private var backgroundPathColor: UIColor {
        switch (isHighlighted, isSelected) {
        case (true, _):
            return .protonomeMedium(hue: colorHue, saturation: colorSaturation)
        case (_, true):
            return .protonomeDark(hue: colorHue, saturation: colorSaturation)
        default:
            return .protonomeDarkGray
        }
    }
    
    private var foregroundPathColor: UIColor {
        return .protonomeLight(hue: colorHue, saturation: colorSaturation)
    }
    
}

extension AudioPlot: CsoundBinding {
    
    open func setup(_ csoundObj: CsoundObj) {
        csound = csoundObj
    }
    
    open func updateValuesFromCsound() {
        guard let csound = csound else {
            return
        }
        
        data = csound.getOutSamples()
        
        var samples = [Float](repeating: 0.0, count: data.count / MemoryLayout<Float>.size)
        
        (data as NSData).getBytes(&samples, length:data.count)
        
        DispatchQueue.main.async {
            self.samples = samples
        }
    }
    
}
