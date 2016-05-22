//
//  Lerp.swift
//  Lerp
//
//  Created by Daniel Clelland on 6/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Lerpable protocol

public protocol Lerpable {
    func lerp(min min: Self, max: Self) -> Self
    func ilerp(min min: Self, max: Self) -> Self
}

// MARK: Lerpable global functions

/**
Calculates the linear interpolation between a minimum and a maximum value.

- parameter weighting: The input weighting. Typically in the range `0...1` but other values are supported.
- parameter min: The minimum value.
- parameter max: The maximum value.

- returns: The weighted average. Typically in the range `min...max` but other values are supported.
*/

public func lerp<T: Lerpable>(weighting: T, min: T, max: T) -> T {
    return weighting.lerp(min: min, max: max)
}

/**
Calculates the inverse linear interpolation between a minimum and a maximum value.

- parameter value: The input value. Typically in the range `min...max` but other values are supported.
- parameter min: The minimum value.
- parameter max: The maximum value.

- returns: The weighting of *value* between *min* and *max*. Typically in the range `0...1` but other values are supported.
*/

public func ilerp<T: Lerpable>(value: T, min: T, max: T) -> T {
    return value.ilerp(min: min, max: max)
}

// MARK: Lerpable implementations

extension Double: Lerpable {
    
    /// Linear interpolation
    public func lerp(min min: Double, max: Double) -> Double {
        return min + (self * (max - min))
    }
    
    /// Inverse linear interpolation
    public func ilerp(min min: Double, max: Double) -> Double {
        return (self - min) / (max - min)
    }
    
}

extension Float: Lerpable {
    
    /// Linear interpolation
    public func lerp(min min: Float, max: Float) -> Float {
        return min + (self * (max - min))
    }
    
    /// Inverse linear interpolation
    public func ilerp(min min: Float, max: Float) -> Float {
        return (self - min) / (max - min)
    }
    
}

extension CGFloat: Lerpable {
    
    /// Linear interpolation
    public func lerp(min min: CGFloat, max: CGFloat) -> CGFloat {
        return min + (self * (max - min))
    }
    
    /// Inverse linear interpolation
    public func ilerp(min min: CGFloat, max: CGFloat) -> CGFloat {
        return (self - min) / (max - min)
    }
    
}

// MARK: Clampable protocol

public protocol Clampable {
    func clamp(min min: Self, max: Self) -> Self
}

// MARK: Clampable global functions

/**
Clamps the value between an lower and upper bound.

- parameter value: The input value.
- parameter min: The lower bound.
- parameter max: The upper bound.

- returns: Returns *min* if *value* is less than min, or *max* if *value* is greater than *max*. *min* and *max* can safely be swapped.
*/

public func clamp<T: Clampable>(value: T, min: T, max: T) -> T {
    return value.clamp(min: min, max: max)
}

// MARK: Clampable implementations

extension Double: Clampable {
    
    /// Clamp
    public func clamp(min min: Double, max: Double) -> Double {
        return Swift.min(Swift.max(self, Swift.min(min, max)), Swift.max(min, max))
    }
    
}

extension Float: Clampable {
    
    /// Clamp
    public func clamp(min min: Float, max: Float) -> Float {
        return Swift.min(Swift.max(self, Swift.min(min, max)), Swift.max(min, max))
    }
    
}

extension CGFloat: Clampable {
    
    /// Clamp
    public func clamp(min min: CGFloat, max: CGFloat) -> CGFloat {
        return Swift.min(Swift.max(self, Swift.min(min, max)), Swift.max(min, max))
    }
    
}
