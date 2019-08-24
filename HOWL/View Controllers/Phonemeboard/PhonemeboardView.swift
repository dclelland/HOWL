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

@IBDesignable class PhonemeboardView: AudioPlot {
    
    private let trailLength = 24
    
    private var trailLocation: CGPoint? {
        return Audio.client?.vocoder.location
    }
    
    private var trailLocations = [CGPoint?]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Overrides
    
#if !TARGET_INTERFACE_BUILDER
    override func updateValuesFromCsound() {
        super.updateValuesFromCsound()
        
        DispatchQueue.main.async {
            let trailLocation = self.trailLocation
            let trailLocations = self.trailLocations
            
            let colorHue = self.trailHue
            let colorSaturation = self.trailSaturation
            
            DispatchQueue.main.async(flags: .barrier) {
                self.trailLocations = Array(([trailLocation] + trailLocations).prefix(self.trailLength))
                self.colorHue = colorHue
                self.colorSaturation = colorSaturation
            }
        }
    }
#endif
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if (self.isSelected) {
            context.setFillColor(trailPathColor.cgColor)
            trailPath.fill()
        }
    }
    
    // MARK: - Private getters
    
    private var trailPath: UIBezierPath {
        let path = UIBezierPath { path in
            trailLocations.compactMap { $0 }.enumerated().forEach { index, location in
                let ratio = CGFloat(index).ilerp(min: 0.0, max: CGFloat(trailLength)).lerp(min: 1.0, max: 0.0)
                let radius = pow(ratio, 2.0) * 24.0
                path.add(.oval, center: location.lerp(rect: bounds), radius: radius)
            }
        }
        
        return path
    }
    
    private var trailPathColor: UIColor {
        return .protonomeLight(hue: colorHue, saturation: colorSaturation)
    }
    
    private var trailHue: CGFloat {
        guard let location = trailLocation else {
            return 0.0
        }
        
        let angle = atan2(location.x - 0.5, location.y - 0.5)
        
        return (angle + .pi) / (2.0 * .pi)
    }
    
    private var trailSaturation: CGFloat {
        guard let location = trailLocation else {
            return 0.0
        }
        
        let distance = hypot(location.x - 0.5, location.y - 0.5)
        
        return distance * 2.0
    }
    
}
