//
//  Keyboard.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy

class Keyboard {
    
    var leftInterval: Int
    var rightInterval: Int
    
    var horizontalRadius: Int = 4
    var verticalRadius: Int = 5
    
    var centerPitch: Int = 48
    
    init(leftInterval: Int, rightInterval: Int) {
        self.leftInterval = leftInterval
        self.rightInterval = rightInterval
    }
    
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
            
            return Key(withPitch: pitch, path: path, coordinates: coordinates)
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
    
    // MARK: - Keyboard coordinates
    
    private func coordinatesForIndex(index: Int, inRow row: Int) -> KeyCoordinates? {
        if row >= numberOfRows() || index >= numberOfKeysInRow(row) {
            return nil
        }
        
        let x = rowIsOffset(row) ? index * 2 + 1 : index * 2
        let y = row
        
        let verticalOffset = verticalRadius - y
        let horizontalOffset = horizontalRadius - x
        
        let left = Float(verticalOffset + horizontalOffset) / 2
        let right = Float(verticalOffset - horizontalOffset) / 2
        
        return KeyCoordinates(left: Int(left), right: Int(right))
    }
    
    private func rowIsOffset(row: Int) -> Bool {
        if horizontalRadius.parity == verticalRadius.parity {
            return row.isOdd
        } else {
            return row.isEven
        }
    }
    
    // MARK: - Transforms
    
    private func pitchForCoordinates(coordinates: KeyCoordinates) -> Int {
        return centerPitch + coordinates.left * leftInterval + coordinates.right * rightInterval
    }
    
    private func pathForCoordinates(coordinates: KeyCoordinates) -> UIBezierPath {
        let location = locationForCoordinates(coordinates)
        
        let horizontalKeyRadius = 1.0 / (2.0 * CGFloat(horizontalRadius))
        let verticalKeyRadius = 1.0 / (2.0 * CGFloat(verticalRadius))
        
        return UIBezierPath.makePath { make in
            make.move(x: location.x, y: location.y - verticalKeyRadius)
            make.line(x: location.x + horizontalKeyRadius, y: location.y)
            make.line(x: location.x, y: location.y + verticalKeyRadius)
            make.line(x: location.x - horizontalKeyRadius, y: location.y)
            make.closed()
        }
    }
    
    private func locationForCoordinates(coordinates: KeyCoordinates) -> CGPoint {
        let horizontalKeyRadius = 1.0 / CGFloat(horizontalRadius) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(verticalRadius) / 2.0
        
        let leftDifference = CGVector(dx: -horizontalKeyRadius * CGFloat(coordinates.left), dy: -verticalKeyRadius * CGFloat(coordinates.left))
        let rightDifference = CGVector(dx: horizontalKeyRadius * CGFloat(coordinates.right), dy: -verticalKeyRadius * CGFloat(coordinates.right))
        
        return CGPoint(x: 0.5 + leftDifference.dx + rightDifference.dx, y: 0.5 + leftDifference.dy + rightDifference.dy)
    }
}
