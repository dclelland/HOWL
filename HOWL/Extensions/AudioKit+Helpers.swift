//
//  AudioKit+Helpers.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/3/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import AudioKit
import Persistable

// MARK: Instrument properties

class InstrumentProperty: AKInstrumentProperty, Persistable {
    
    typealias PersistentType = Float
    
    override var value: Float {
        didSet {
            self.persistentValue = value
        }
    }
    
    let defaultValue: Float
    
    let persistentKey: String
    
    init(value: Float, key: String) {
        self.defaultValue = value
        self.persistentKey = key
        
        super.init()
        
        self.register(defaultPersistentValue: value)
        
        self.value = self.persistentValue
        self.initialValue = value
    }
    
}

// MARK: Instruments

extension AKInstrument {
    
    var instrumentProperties: [InstrumentProperty] {
        return properties.flatMap { $0 as? InstrumentProperty }
    }
    
    func reset() {
        for instrumentProperty in instrumentProperties {
            instrumentProperty.reset()
        }
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
    return left.scaled(by: right)
}

func /<T: AKParameter, U: AKParameter> (left: T, right: U) -> T {
    return left.divided(by: right)
}

// MARK: Trig functions

func sin(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sin", input: x)
}

func cos(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cos", input: x)
}

func tan(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tan", input: x)
}

func sinh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "sinh", input: x)
}

func cosh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "cosh", input: x)
}

func tanh(_ x: AKParameter) -> AKParameter {
    return AKSingleInputMathOperation(functionString: "tanh", input: x)
}
