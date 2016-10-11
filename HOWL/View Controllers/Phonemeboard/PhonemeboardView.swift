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
    
    private var trailLocations = [CGPoint?]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Overrides
    
    override func updateValuesFromCsound() {
        super.updateValuesFromCsound()
        
        let trailLocations: [CGPoint?] = {
            guard self.isSelected == true else {
                return []
            }
            
            let trailLocation = self.trailLocation
            let trailLocations = self.trailLocations
        
            return Array(([trailLocation] + trailLocations).prefix(self.trailLength))
        }()
        
        let colorHue = self.trailHue
        let colorSaturation = self.trailSaturation
        
        DispatchQueue.main.async {
            self.trailLocations = trailLocations
            self.colorHue = colorHue
            self.colorSaturation = colorSaturation
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if (self.isSelected) {
            context?.setFillColor(trailPathColor.cgColor)
            trailPath.fill()
        }
    }
    
    // MARK: - Private getters
    
    private var trailPath: UIBezierPath {
        let path = UIBezierPath.makePath { make in
            trailLocations.flatMap { $0 }.enumerated().forEach { index, location in
                let ratio = CGFloat(index).ilerp(min: 0.0, max: CGFloat(trailLength)).lerp(min: 1.0, max: 0.0)
                let radius = pow(ratio, 2.0) * 24.0
                make.oval(at: location, radius: radius)
            }
        }
        
        return path
    }
    
    private var trailPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: colorHue, saturation: colorSaturation)
    }
    
    private var trailLocation: CGPoint? {
        return Audio.client?.vocoder.location.lerp(rect: bounds)
    }
    
    private var trailHue: CGFloat {
        guard let location = Audio.client?.vocoder.location else {
            return 0.0
        }
        
        let angle = atan2(location.x - 0.5, location.y - 0.5)
        
        return (angle + CGFloat(M_PI)) / (2.0 * CGFloat(M_PI))
    }
    
    private var trailSaturation: CGFloat {
        guard let location = Audio.client?.vocoder.location else {
            return 0.0
        }
        
        let distance = hypot(location.x - 0.5, location.y - 0.5)
        
        return distance * 2.0
    }
    
}
