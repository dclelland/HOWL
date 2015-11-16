//
//  Keyboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

struct KeyboardCoordinates {
    var leftAxis: Int
    var rightAxis: Int
    
    init(withLeftAxis leftAxis: Int, rightAxis: Int) {
        self.leftAxis = leftAxis
        self.rightAxis = rightAxis
    }
}

class Keyboard {
    
    var centerPitch = 40
    
    var leftAxisInterval = 4
    var rightAxisInterval = 7
    
    var verticalRadius = 4
    var horizontalRadius = 3
    
    func numberOfKeys() -> Int {
        let oddRowCount: Int = verticalRadius / 2 * 2 + 1
        let oddColumnCount: Int = horizontalRadius / 2 * 2 + 1
        let evenRowCount: Int = (verticalRadius + 1) / 2 * 2
        let evenColumnCount: Int = (horizontalRadius + 1) / 2 * 2
        
        return oddRowCount * oddColumnCount + evenRowCount * evenColumnCount
    }
    
    func keyAtIndex(index: Int) -> KeyboardKey? {
        let coordinates = self.coordinatesForIndex(index)
        
        let pitch = self.pitchForCoordinates(coordinates)
        let location = self.locationForCoordinates(coordinates)
        
        return KeyboardKey.init(withPitch: pitch, location: location, value: 0.0)
    }
    
    // MARK: - Transforms
    
    func coordinatesForIndex(index: Int) -> KeyboardCoordinates {
        return KeyboardCoordinates(withLeftAxis: 0, rightAxis: 0)
    }
    
    // MARK: - Key attributes
    
    func pitchForCoordinates(coordinates: KeyboardCoordinates) -> Int {
        return centerPitch + coordinates.leftAxis * leftAxisInterval + coordinates.rightAxis * rightAxisInterval
    }
    
    func locationForCoordinates(coordinates: KeyboardCoordinates) -> CGPoint {
        return CGPointMake(0.5, 0.5)
    }
}

extension Keyboard {
    
    // MARK: - Drawing
    
    func pathForKeyAtIndex(index: Int, inBounds bounds: CGRect) -> UIBezierPath {
        let coordinates = self.coordinatesForIndex(index)
        let location = self.locationForCoordinates(coordinates)
        
        let scale = CGAffineTransformMakeScale(bounds.width, bounds.height)
        let translation = CGAffineTransformMakeTranslation(bounds.minX, bounds.minY)

        let center = CGPointApplyAffineTransform(location, CGAffineTransformConcat(scale, translation))
        
        let verticalRadius = bounds.height / CGFloat(self.verticalRadius) / 2.0
        let horizontalRadius = bounds.width / CGFloat(self.horizontalRadius) / 2.0
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(center.x, center.y - verticalRadius))
        path.addLineToPoint(CGPointMake(center.x + horizontalRadius, center.y))
        path.addLineToPoint(CGPointMake(center.x, center.y + verticalRadius))
        path.addLineToPoint(CGPointMake(center.x - horizontalRadius, center.y))
        path.closePath()
        
        return path
    }
}
