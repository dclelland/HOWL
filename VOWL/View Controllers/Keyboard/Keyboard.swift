//
//  Keyboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Keyboard {
    
    struct Coordinates {
        var leftAxis: Int
        var rightAxis: Int
        
        init(withLeftAxis leftAxis: Int, rightAxis: Int) {
            self.leftAxis = leftAxis
            self.rightAxis = rightAxis
        }
    }
    
    var centerPitch = 40
    
    var leftAxisInterval = 4
    var rightAxisInterval = 7
    
    var horizontalRadius = 4
    var verticalRadius = 5
    
    // MARK: - Counts
    
    func numberOfRows() -> Int {
        return verticalRadius * 2 + 1
    }
    
    func numberOfKeysInRow(row: Int) -> Int {
        switch self.parityForRow(row) {
        case .Even:
            return horizontalRadius.isEven() ? horizontalRadius : horizontalRadius + 1
        case .Odd:
            return horizontalRadius.isOdd() ? horizontalRadius : horizontalRadius + 1
        }
    }
    
    // MARK: - Keys
    
    func keyAtIndex(index: Int, inRow row: Int) -> KeyboardKey? {
        let coordinates = self.coordinatesForIndex(index, inRow: row)
        let pitch = self.pitchForCoordinates(coordinates)
        let location = self.locationForCoordinates(coordinates)
        
        return KeyboardKey.init(withPitch: pitch, location: location, value: 0.0)
    }
    
    // MARK: - Paths
    
    func pathForKeyAtIndex(index: Int, inRow row: Int, withBounds bounds: CGRect) -> UIBezierPath? {
        let coordinates = self.coordinatesForIndex(index, inRow: row)
        let location = self.locationForCoordinates(coordinates)
        
        let scale = CGAffineTransformMakeScale(bounds.width, bounds.height)
        let translation = CGAffineTransformMakeTranslation(bounds.minX, bounds.minY)
        
        let center = CGPointApplyAffineTransform(location, CGAffineTransformConcat(scale, translation))
        
        let horizontalKeyRadius = bounds.width / CGFloat(horizontalRadius) / 2.0
        let verticalKeyRadius = bounds.height / CGFloat(verticalRadius) / 2.0
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(center.x, center.y - verticalKeyRadius))
        path.addLineToPoint(CGPointMake(center.x + horizontalKeyRadius, center.y))
        path.addLineToPoint(CGPointMake(center.x, center.y + verticalKeyRadius))
        path.addLineToPoint(CGPointMake(center.x - horizontalKeyRadius, center.y))
        path.closePath()
        
        return path
    }
    
    // MARK: - Coordinates
    
    private func coordinatesForIndex(index: Int, inRow row: Int) -> Coordinates {
        let x = horizontalRadius.parity() == verticalRadius.parity()
            ? row.isEven() ? index * 2 : index * 2 + 1
            : row.isOdd() ? index * 2 : index * 2 + 1
        let y = row
        
        let verticalOffset = verticalRadius - y
        let horizontalOffset = horizontalRadius - x
        
        let leftAxis = Float(verticalOffset + horizontalOffset) / 2
        let rightAxis = Float(verticalOffset - horizontalOffset) / 2
        
        print("row: \(row); index: \(index); x: \(x); y: \(y); left: \(leftAxis); right: \(rightAxis)")
        
        return Coordinates(withLeftAxis: Int(leftAxis), rightAxis: Int(rightAxis))
    }
    
    // MARK: - Coordinates transforms
    
    private func pitchForCoordinates(coordinates: Coordinates) -> Int {
        return centerPitch + coordinates.leftAxis * leftAxisInterval + coordinates.rightAxis * rightAxisInterval
    }
    
    private func locationForCoordinates(coordinates: Coordinates) -> CGPoint {
        let horizontalKeyRadius = 1.0 / CGFloat(horizontalRadius) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(verticalRadius) / 2.0
        
        let leftAxisDifference = CGVectorMake(-horizontalKeyRadius * CGFloat(coordinates.leftAxis), -verticalKeyRadius * CGFloat(coordinates.leftAxis))
        let rightAxisDifference = CGVectorMake(horizontalKeyRadius * CGFloat(coordinates.rightAxis), -verticalKeyRadius * CGFloat(coordinates.rightAxis))
        
        return CGPointMake(0.5 + leftAxisDifference.dx + rightAxisDifference.dx, 0.5 + leftAxisDifference.dy + rightAxisDifference.dy)
    }
    
    // MARK: - Row parity
    
    enum RowParity {
        case Even
        case Odd
    }
    
    private func parityForRow(row: Int) -> RowParity {
        return row.parity() == verticalRadius.parity() ? .Odd : .Even
    }
}
