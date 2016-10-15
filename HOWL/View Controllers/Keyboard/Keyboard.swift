//
//  Keyboard.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Parity

class Keyboard {
    
    var width: Int
    var height: Int
    
    var leftInterval: Int
    var rightInterval: Int
    
    var centerPitch: Pitch
    
    init(width: Int, height: Int, leftInterval: Int, rightInterval: Int, centerPitch: Pitch = 48) {
        self.width = width
        self.height = height
        self.leftInterval = leftInterval
        self.rightInterval = rightInterval
        self.centerPitch = centerPitch
    }
    
    // MARK: - Counts
    
    var numberOfRows: Int {
        return height * 2 + 1
    }
    
    func numberOfKeys(in row: Int) -> Int {
        return rowIsOffset(row) ? width : height + 1
    }
    
    // MARK: - Keys
    
    func key(at index: Int, in row: Int) -> Key? {
        guard let coordinates = coordinates(for: index, in: row) else {
            return nil
        }
        
        let pitch = self.pitch(for: coordinates)
        let path = self.path(for: coordinates)
        
        return Key(pitch: pitch, path: path, coordinates: coordinates)
    }
    
    func key(at location: CGPoint) -> Key? {
        for row in 0..<numberOfRows {
            for index in 0..<numberOfKeys(in: row) {
                if let key = key(at: index, in: row), key.path.contains(location) {
                    return key
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Keyboard coordinates
    
    private func coordinates(for index: Int, in row: Int) -> KeyCoordinates? {
        guard row < numberOfRows && index < numberOfKeys(in: row) else {
            return nil
        }
        
        let x = rowIsOffset(row) ? index * 2 + 1 : index * 2
        let y = row
        
        let verticalOffset = height - y
        let horizontalOffset = width - x
        
        let left = Float(verticalOffset + horizontalOffset) / 2
        let right = Float(verticalOffset - horizontalOffset) / 2
        
        return KeyCoordinates(left: Int(left), right: Int(right))
    }
    
    private func rowIsOffset(_ row: Int) -> Bool {
        if width.parity == height.parity {
            return row.isOdd
        } else {
            return row.isEven
        }
    }
    
    // MARK: - Transforms
    
    private func pitch(for coordinates: KeyCoordinates) -> Pitch {
        return Pitch(number: centerPitch.number + coordinates.left * leftInterval + coordinates.right * rightInterval)
    }
    
    private func path(for coordinates: KeyCoordinates) -> UIBezierPath {
        let location = self.location(for: coordinates)
        
        let horizontalKeyRadius = 1.0 / CGFloat(width) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(height) / 2.0
        
        return UIBezierPath { path in
            path.add(.move, x: location.x, y: location.y - verticalKeyRadius)
            path.add(.line, x: location.x + horizontalKeyRadius, y: location.y)
            path.add(.line, x: location.x, y: location.y + verticalKeyRadius)
            path.add(.line, x: location.x - horizontalKeyRadius, y: location.y)
            path.close()
        }
    }
    
    private func location(for coordinates: KeyCoordinates) -> CGPoint {
        let horizontalKeyRadius = 1.0 / CGFloat(width) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(height) / 2.0
        
        let leftDifference = CGVector(
            dx: -horizontalKeyRadius * CGFloat(coordinates.left),
            dy: -verticalKeyRadius * CGFloat(coordinates.left)
        )
        
        let rightDifference = CGVector(
            dx: horizontalKeyRadius * CGFloat(coordinates.right),
            dy: -verticalKeyRadius * CGFloat(coordinates.right)
        )
        
        return CGPoint(
            x: 0.5 + leftDifference.dx + rightDifference.dx,
            y: 0.5 + leftDifference.dy + rightDifference.dy
        )
    }
}
