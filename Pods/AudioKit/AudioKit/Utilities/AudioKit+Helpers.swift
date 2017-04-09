//
//  AudioKit+Helpers.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/3/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

// MARK: Conversion

/// Protocol for converting numeric values to AKConstants.
public protocol AKConvertible {
    
    /// Get an AKConstant.
    var ak: AKConstant { get }

}

extension UInt: AKConvertible {
    
    /// Get an AKConstant.
    public var ak: AKConstant {
        return AKConstant(integer: Int(self))
    }
    
}

extension Int: AKConvertible {
    
    /// Get an AKConstant.
    public var ak: AKConstant {
        return AKConstant(integer: self)
    }

}

extension Float: AKConvertible {
    
    /// Get an AKConstant.
    public var ak: AKConstant {
        return AKConstant(float: self)
    }

}

extension Double: AKConvertible {
    
    /// Get an AKConstant.
    public var ak: AKConstant {
        return AKConstant(float: Float(self))
    }

}

// MARK: Operators

/// Sum two parameters.
public func +<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.plus(right)
}

/// Subtract one parameter from another.
public func -<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.minus(right)
}

/// Multiply two parameters.
public func *<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.scaled(by: right)
}

/// Divide one parameter by another.
public func /<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.divided(by: right)
}

// MARK: Trig functions

/// Take the sine of a parameter.
public func sin(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sin", input: x)
}

/// Take the cosine of a parameter.
public func cos(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cos", input: x)
}

/// Take the tangent of a parameter.
public func tan(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tan", input: x)
}

/// Take the hyperbolic sine of a parameter.
public func sinh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sinh", input: x)
}

/// Take the hyperbolic cosine of a parameter.
public func cosh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cosh", input: x)
}

/// Take the hyperbolic tangent of a parameter.
public func tanh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tanh", input: x)
}
