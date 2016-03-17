//
//  Lerp.swift
//  Lerp
//
//  Created by Daniel Clelland on 6/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Constants

public let π: Double = M_PI

// MARK: Postfix operators

postfix operator ° {}

public postfix func °<T: Degradable> (angle: T) -> T {
    return deg2rad(angle)
}

// MARK: Degradable protocol

public protocol Degradable {
    var degrees: Self { get }
    var radians: Self { get }
}

// MARK: Degradable global functions

/**
Converts degrees to radians.

- parameter angle: The input angle, assumed to be in degrees.

- returns: The angle's value in radians.
*/

public func deg2rad<T: Degradable>(angle: T) -> T {
    return angle.degrees
}

/**
Converts radians to degrees.

- parameter angle: The input angle, assumed to be in radians.

- returns: The angle's value in degrees.
*/

public func rad2deg<T: Degradable>(angle: T) -> T {
    return angle.radians
}

// MARK: Degradable implementations

extension Double: Degradable {
  
    /// Self (in degrees) value in radians
    public var degrees: Double {
        return self * π / 180.0
    }
    
    /// Self (in radians) value in degrees
    public var radians: Double {
        return self * 180.0 / π
    }
    
}

extension Float: Degradable {
  
    /// Self (in degrees) value in radians
    public var degrees: Float {
        return self * Float(π) / 180.0
    }
    
    /// Self (in radians) value in degrees
    public var radians: Float {
        return self * 180.0 / Float(π)
    }
    
}

extension CGFloat: Degradable {
  
    /// Self (in degrees) value in radians
    public var degrees: CGFloat {
        return self * CGFloat(π) / 180.0
    }
    
    /// Self (in radians) value in degrees
    public var radians: CGFloat {
        return self * 180.0 / CGFloat(π)
    }
    
}

// MARK: Polrectable protocol

public protocol Polrectable {
    static func rec2pol(x x: Self, y: Self) -> (r: Self, θ: Self)
    static func pol2rec(r r: Self, θ: Self) -> (x: Self, y: Self)
}

// MARK: Polrectable global functions

/**
Converts rectangular coordinates to polar coordinates.

- parameter x: The x coordinate.
- parameter y: The y coordinate.

- returns: A tuple `(r, θ)` with the polar coordinates.
*/
public func rec2pol<T: Polrectable>(x x: T, y: T) -> (r: T, θ: T) {
    return T.rec2pol(x: x, y: y)
}

/**
Converts polar coordinates to rectangular coordinates.
 
- parameter r: The coordinate's radius.
- parameter θ: The coordinate's angle.
 
- returns: A tuple `(x, y)` with the rectangular coordinates.
*/
public func pol2rec<T: Polrectable>(r r: T, θ: T) -> (x: T, y: T) {
    return T.pol2rec(r: r, θ: θ)
}

// MARK: Polrectable implementations

extension Double: Polrectable {
    
    /// Converts rectangular coordinates to polar coordinates
    public static func rec2pol(x x: Double, y: Double) -> (r: Double, θ: Double) {
        return (r: hypot(y, x), θ: atan2(y, x))
    }
    
    /// Converts polar coordinates to rectangular coordinates
    public static func pol2rec(r r: Double, θ: Double) -> (x: Double, y: Double) {
        return (x: r * cos(θ), y: r * sin(θ))
    }
    
}

extension Float: Polrectable {
    
    /// Converts rectangular coordinates to polar coordinates
    public static func rec2pol(x x: Float, y: Float) -> (r: Float, θ: Float) {
        return (r: hypot(y, x), θ: atan2(y, x))
    }
    
    /// Converts polar coordinates to rectangular coordinates
    public static func pol2rec(r r: Float, θ: Float) -> (x: Float, y: Float) {
        return (x: r * cos(θ), y: r * sin(θ))
    }
    
}

extension CGFloat: Polrectable {
    
    /// Converts rectangular coordinates to polar coordinates
    public static func rec2pol(x x: CGFloat, y: CGFloat) -> (r: CGFloat, θ: CGFloat) {
        return (r: hypot(y, x), θ: atan2(y, x))
    }
    
    /// Converts polar coordinates to rectangular coordinates
    public static func pol2rec(r r: CGFloat, θ: CGFloat) -> (x: CGFloat, y: CGFloat) {
        return (x: r * cos(θ), y: r * sin(θ))
    }
    
}
