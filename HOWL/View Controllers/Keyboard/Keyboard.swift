//
//  Keyboard.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Keyboard {
    
    var centerPitch = 48
    
    var leftInterval = 4
    var rightInterval = 7
    
    var horizontalRadius = 4
    var verticalRadius = 5
    
    // MARK: - Counts
    
    func numberOfRows() -> Int {
        return verticalRadius * 2 + 1
    }
    
    func numberOfKeysInRow(row: Int) -> Int {
        return rowIsOffset(row) ? horizontalRadius : horizontalRadius + 1
    }
    
    // MARK: - Keys
    
    func keyAtIndex(index: Int, inRow row: Int) -> Key? {
        if let coordinates = coordinatesForIndex(index, inRow: row) {
            let pitch = pitchForCoordinates(coordinates)
            let path = pathForCoordinates(coordinates)
            
            return Key(withPitch: pitch, path: path)
        }
        
        return nil
    }
    
    func keyAtLocation(location: CGPoint) -> Key? {
        for row in 0..<numberOfRows() {
            for index in 0..<numberOfKeysInRow(row) {
                if let key = keyAtIndex(index, inRow: row) where key.path.containsPoint(location) {
                    return key
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Coordinates
    
    private struct Coordinates {
        var left: Int
        var right: Int
    }
    
    private func coordinatesForIndex(index: Int, inRow row: Int) -> Coordinates? {
        if row >= numberOfRows() || index >= numberOfKeysInRow(row) {
            return nil
        }
        
        let x = rowIsOffset(row) ? index * 2 + 1 : index * 2
        let y = row
        
        let verticalOffset = verticalRadius - y
        let horizontalOffset = horizontalRadius - x
        
        let left = Float(verticalOffset + horizontalOffset) / 2
        let right = Float(verticalOffset - horizontalOffset) / 2
        
        return Coordinates(left: Int(left), right: Int(right))
    }
    
    private func rowIsOffset(row: Int) -> Bool {
        if horizontalRadius.parity == verticalRadius.parity {
            return row.isOdd
        } else {
            return row.isEven
        }
    }
    
    // MARK: - Transforms
    
    private func pitchForCoordinates(coordinates: Coordinates) -> Int {
        return centerPitch + coordinates.left * leftInterval + coordinates.right * rightInterval
    }
    
    private func pathForCoordinates(coordinates: Coordinates) -> UIBezierPath {
        let location = locationForCoordinates(coordinates)
        
        let horizontalKeyRadius = 1.0 / (2.0 * CGFloat(horizontalRadius))
        let verticalKeyRadius = 1.0 / (2.0 * CGFloat(verticalRadius))
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(location.x, location.y - verticalKeyRadius))
        path.addLineToPoint(CGPointMake(location.x + horizontalKeyRadius, location.y))
        path.addLineToPoint(CGPointMake(location.x, location.y + verticalKeyRadius))
        path.addLineToPoint(CGPointMake(location.x - horizontalKeyRadius, location.y))
        path.closePath()
        
        return path
    }
    
    private func locationForCoordinates(coordinates: Coordinates) -> CGPoint {
        let horizontalKeyRadius = 1.0 / CGFloat(horizontalRadius) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(verticalRadius) / 2.0
        
        let leftDifference = CGVectorMake(-horizontalKeyRadius * CGFloat(coordinates.left), -verticalKeyRadius * CGFloat(coordinates.left))
        let rightDifference = CGVectorMake(horizontalKeyRadius * CGFloat(coordinates.right), -verticalKeyRadius * CGFloat(coordinates.right))
        
        return CGPointMake(0.5 + leftDifference.dx + rightDifference.dx, 0.5 + leftDifference.dy + rightDifference.dy)
    }
}
