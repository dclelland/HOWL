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
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if (self.selected) {
            CGContextSetFillColorWithColor(context, UIColor.protonome_blackColor().CGColor)
            trailPath.fill()
        }
    }
    
    private let trailLength = 24
    
    private var trailPath: UIBezierPath {
        trailLocations = Array(([trailLocation] + trailLocations).prefix(trailLength))
        
        let path = UIBezierPath.makePath { make in
            trailLocations.enumerate().forEach { index, location in
                make.oval(at: location, radius: CGFloat(trailLength - index))
            }
        }
        
        return path
    }
    
    private lazy var trailLocations = [CGPoint]()
    
    private var trailLocation: CGPoint {
        let x = CGFloat(Audio.vocoder.xOut.value).lerp(min: bounds.minX, max: bounds.maxX)
        let y = CGFloat(Audio.vocoder.yOut.value).lerp(min: bounds.minY, max: bounds.maxY)
        
        return CGPoint(x: x, y: y)
    }
    
}
