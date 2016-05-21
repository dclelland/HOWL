//
//  PhonemeboardView.swift
//  HOWL
//
//  Created by Daniel Clelland on 21/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Lerp
import ProtonomeAudioKitControls

class PhonemeboardView: AudioPlot {
    
    private let trailLength = 24
    
    private var trailLocations = [CGPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Overrides
    
    override func updateValuesFromCsound() {
        super.updateValuesFromCsound()
        
        let locations = Array(([trailLocation] + trailLocations).prefix(trailLength))
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.trailLocations = locations
        })
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if (self.selected) {
            CGContextSetFillColorWithColor(context, UIColor.protonome_blackColor().CGColor)
            trailPath.fill()
        }
    }
    
    // MARK: - Private getters
    
    private var trailPath: UIBezierPath {
        let path = UIBezierPath.makePath { make in
            trailLocations.enumerate().forEach { index, location in
                make.oval(at: location, radius: CGFloat(trailLength - index) * 0.5)
            }
        }
        
        return path
    }
    
    private var trailLocation: CGPoint {
        let x = CGFloat(Audio.vocoder.xOut.value).lerp(min: bounds.minX, max: bounds.maxX)
        let y = CGFloat(Audio.vocoder.yOut.value).lerp(min: bounds.minY, max: bounds.maxY)
        
        return CGPoint(x: x, y: y)
    }
    
}
