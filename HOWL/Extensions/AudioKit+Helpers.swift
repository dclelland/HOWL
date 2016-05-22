//
//  AudioKit+Helpers.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/3/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import AudioKit

// MARK: Conversion

protocol AKConvertible {
    
    var ak: AKConstant { get }

}

extension Int: AKConvertible {

    var ak: AKConstant {
        return AKConstant(integer: self)
    }

}

extension Float: AKConvertible {

    var ak: AKConstant {
        return AKConstant(float: self)
    }

}

extension Double: AKConvertible {

    var ak: AKConstant {
        return AKConstant(float: Float(self))
    }

}

// MARK: Operators

func +<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.plus(right)
}

func -<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.minus(right)
}

func *<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.scaledBy(right)
}

func /<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.dividedBy(right)
}
