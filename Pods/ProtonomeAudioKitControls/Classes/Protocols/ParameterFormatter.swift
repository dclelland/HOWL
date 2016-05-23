//
//  ParameterFormatter.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

/// A protocol which describes a conversion from a value to a formatted string.
public protocol ParameterFormatter {
    
    /// Converts a value to a formatted string.
    func string(forValue value: Float) -> String?
    
}

/// A protocol which describes the construction of an `NSNumberFormatter`, which may be used by `ParameterFormatterConstructor`'s default implementation to implement the `ParameterFormatter` protocol.
public protocol ParameterFormatterConstructor: ParameterFormatter {
    
    /// Constructs an NSNumberFormatter for a given value.
    func formatter(forValue value: Float) -> NSNumberFormatter
    
}

extension ParameterFormatterConstructor {
    
    public func string(forValue value: Float) -> String? {
        // Don't print negative zero
        guard (value.floatingPointClass != .NegativeZero) else {
            return formatter(forValue: 0.0).stringFromNumber(NSNumber(float: 0.0))
        }
        
        return formatter(forValue: value).stringFromNumber(NSNumber(float: value))
    }
    
}

/// A parameter formatter class which formats numbers, e.g.: `"1.2"`.
public struct NumberParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0..<0.01:
            return NSNumberFormatter(digits: 1)
        case 0.01..<1.0:
            return NSNumberFormatter(digits: 2)
        default:
            return NSNumberFormatter(digits: 1)
        }
    }
    
}

/// A parameter formatter class which formats integers, e.g.: `"6"`.
public struct IntegerParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        return NSNumberFormatter(digits: 0)
    }
    
}

/// A parameter formatter class which formats percentages, e.g.: `"50%"` for the value `7.5`.
public struct PercentageParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        return NSNumberFormatter(digits: 0, multiplier: 100.0, suffix: "%")
    }
    
}

/// A parameter formatter class which formats durations, e.g.: `"40ms"` for the value `0.04`.
public struct DurationParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0:
            return NSNumberFormatter(digits: 1, suffix: "s")
        case 0.0..<0.00001:
            return NSNumberFormatter(digits: 1, multiplier: 1000000.0, suffix: "µs")
        case 0.00001..<0.0001:
            return NSNumberFormatter(digits: 2, multiplier: 1000000.0, suffix: "µs", rounding: .SignificantDigits)
        case 0.0001..<0.1:
            return NSNumberFormatter(digits: 2, multiplier: 1000.0, suffix: "ms", rounding: .SignificantDigits)
        case 0.1..<10.0:
            return NSNumberFormatter(digits: 2, suffix: "s", rounding: .SignificantDigits)
        default:
            return NSNumberFormatter(digits: 0, suffix: "s")
        }
    }
    
}

/// A parameter formatter class which formats amplitudes, e.g.: `"6.0dB"`.
public struct AmplitudeParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0..<10.0:
            return NSNumberFormatter(digits: 1, suffix: "dB")
        default:
            return NSNumberFormatter(digits: 0, suffix: "dB")
        }
    }
    
}

/// A parameter formatter class which formats frequencies, e.g.: `"4.0kHz"` for the value `4000`.
public struct FrequencyParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(forValue value: Float) -> NSNumberFormatter {
        switch (fabs(value)) {
        case 0.0..<1.0:
            return NSNumberFormatter(digits: 1, suffix: "Hz")
        case 1.0..<100.0:
            return NSNumberFormatter(digits: 2, suffix: "Hz", rounding: .SignificantDigits)
        case 100.0..<1000.0:
            return NSNumberFormatter(digits: 3, suffix: "Hz", rounding: .SignificantDigits)
        default:
            return NSNumberFormatter(digits: 2, multiplier: 0.001, suffix: "kHz", rounding: .SignificantDigits)
        }
    }
    
}

/// A parameter formatter class which just returns a custom fixed string value.
public struct StringParameterFormatter: ParameterFormatter {
    
    /// The formatter's string.
    public var string: String?
    
    public func string(forValue value: Float) -> String? {
        return string
    }
    
}

/// A parameter formatter class which picks a name from a stepped sequence, e.g. if `steps` is `[1: "A", 2: "B"]`, then the value `2` is formatted `"B"`.
///
/// Invalid values will return an empty string, in the interest of type safety but at the disregard of sensible behaviour (we'd rather return `""` than crash in the event some process causes an invalid value to be sent here at run time).
///
/// Values must also be unique, in the interest of transitivity.
public struct SteppedParameterFormatter: ParameterFormatter {
    
    /// The formatter's steps - a dictionary of unique values to names.
    public var steps: [Float: String]
    
    public func string(forValue value: Float) -> String? {
        return steps[value] ?? ""
    }

}

// MARK: - Private extensions

private extension NSNumberFormatter {
    
    enum Rounding {
        case FractionDigits
        case SignificantDigits
    }
    
    convenience init(digits: Int, multiplier: Float = 1, suffix: String? = nil, rounding: Rounding = .FractionDigits) {
        self.init()
        self.numberStyle = .DecimalStyle
        
        switch rounding {
        case .FractionDigits:
            self.usesSignificantDigits = false
            self.minimumFractionDigits = digits
            self.maximumFractionDigits = digits
            break
        case .SignificantDigits:
            self.usesSignificantDigits = true
            self.minimumSignificantDigits = digits
            self.maximumSignificantDigits = digits
            break
        }
        
        self.multiplier = multiplier
        
        self.positiveSuffix = suffix
        self.negativeSuffix = suffix
    }
    
}
