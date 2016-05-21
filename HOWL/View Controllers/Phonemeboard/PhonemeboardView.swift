//
//  PhonemeboardView.swift
//  HOWL
//
//  Created by Daniel Clelland on 21/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp
import ProtonomeAudioKitControls

class PhonemeboardView: AudioPlot {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if (self.selected) {
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            touchIndicatorPath.stroke()
        }
    }
    
    // MARK: - Private getters
    
    private let touchIndicatorRadius: CGFloat = 24.0
    
    private var touchIndicatorPath: UIBezierPath {
        let location = touchIndicatorLocation
        
        let x = location.x - touchIndicatorRadius
        let y = location.y - touchIndicatorRadius
        let width = touchIndicatorRadius * 2.0
        let height = touchIndicatorRadius * 2.0
        
        let path = UIBezierPath(ovalInRect: CGRect(x: x, y: y, width: width, height: height))
        
        path.lineWidth = 2.0
        
        return path
    }
    
    private var touchIndicatorLocation: CGPoint {
        let x = CGFloat(Audio.vocoder.xOut.value).lerp(min: bounds.minX, max: bounds.maxX)
        let y = CGFloat(Audio.vocoder.yOut.value).lerp(min: bounds.minY, max: bounds.maxY)
        
        return CGPoint(x: x, y: y)
    }
    
}
