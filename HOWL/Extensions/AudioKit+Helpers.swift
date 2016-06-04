//
//  AudioKit+Helpers.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/3/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import AudioKit

// MARK: Persistence

class InstrumentProperty: AKInstrumentProperty, Persistable {
    
    typealias PersistentType = Float
    
    var persistentKey: String
    
    var defaultValue: Float {
        didSet {
            setDefaultPersistentValue(defaultValue)
        }
    }
    
    override var value: Float {
        didSet {
            NSUserDefaults.standardUserDefaults().setFloat(value, forKey: persistentKey)
        }
    }
    
    init(value: Float, key: String) {
        self.defaultValue = value
        self.persistentKey = key
        
        super.init()
        
        self.value = NSUserDefaults.standardUserDefaults().floatForKey(key)
        self.initialValue = NSUserDefaults.standardUserDefaults().floatForKey(key)
    }
    
}

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

// MARK: Trig functions

func sin(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sin", input: x)
}

func cos(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cos", input: x)
}

func tan(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tan", input: x)
}

func sinh(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sinh", input: x)
}

func cosh(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cosh", input: x)
}

func tanh(x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tanh", input: x)
}
