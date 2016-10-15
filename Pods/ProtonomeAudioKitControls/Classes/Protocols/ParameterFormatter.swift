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
    func string(for value: Float) -> String?
    
}

/// A protocol which describes the construction of an `NSNumberFormatter`, which may be used by `ParameterFormatterConstructor`'s default implementation to implement the `ParameterFormatter` protocol.
public protocol ParameterFormatterConstructor: ParameterFormatter {
    
    /// Constructs an NSNumberFormatter for a given value.
    func formatter(for value: Float) -> NumberFormatter
    
}

extension ParameterFormatterConstructor {
    
    public func string(for value: Float) -> String? {
        // Don't print negative zero
        guard (value.floatingPointClass != .negativeZero) else {
            return formatter(for: 0.0).string(from: NSNumber(value: 0.0 as Float))
        }
        
        return formatter(for: value).string(from: NSNumber(value: value as Float))
    }
    
}

/// A parameter formatter class which formats numbers, e.g.: `"1.2"`.
public struct NumberParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        switch fabs(value) {
        case 0.0..<0.01:
            return NumberFormatter(digits: 1)
        case 0.01..<1.0:
            return NumberFormatter(digits: 2)
        default:
            return NumberFormatter(digits: 1)
        }
    }
    
}

/// A parameter formatter class which formats integers, e.g.: `"6"`.
public struct IntegerParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        return NumberFormatter(digits: 0)
    }
    
}

/// A parameter formatter class which formats percentages, e.g.: `"50%"` for the value `7.5`.
public struct PercentageParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        return NumberFormatter(digits: 0, multiplier: 100.0, suffix: "%")
    }
    
}

/// A parameter formatter class which formats durations, e.g.: `"40ms"` for the value `0.04`.
public struct DurationParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        switch fabs(value) {
        case 0.0:
            return NumberFormatter(digits: 1, suffix: "s")
        case 0.0..<0.00001:
            return NumberFormatter(digits: 1, multiplier: 1000000.0, suffix: "µs")
        case 0.00001..<0.0001:
            return NumberFormatter(digits: 2, multiplier: 1000000.0, suffix: "µs", rounding: .significantDigits)
        case 0.0001..<0.1:
            return NumberFormatter(digits: 2, multiplier: 1000.0, suffix: "ms", rounding: .significantDigits)
        case 0.1..<10.0:
            return NumberFormatter(digits: 2, suffix: "s", rounding: .significantDigits)
        default:
            return NumberFormatter(digits: 0, suffix: "s")
        }
    }
    
}

/// A parameter formatter class which formats amplitudes, e.g.: `"6.0dB"`.
public struct AmplitudeParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        switch fabs(value) {
        case 0.0..<10.0:
            return NumberFormatter(digits: 1, suffix: "dB")
        default:
            return NumberFormatter(digits: 0, suffix: "dB")
        }
    }
    
}

/// A parameter formatter class which formats frequencies, e.g.: `"4.0kHz"` for the value `4000`.
public struct FrequencyParameterFormatter: ParameterFormatterConstructor {
    
    public func formatter(for value: Float) -> NumberFormatter {
        switch (fabs(value)) {
        case 0.0..<1.0:
            return NumberFormatter(digits: 1, suffix: "Hz")
        case 1.0..<100.0:
            return NumberFormatter(digits: 2, suffix: "Hz", rounding: .significantDigits)
        case 100.0..<1000.0:
            return NumberFormatter(digits: 3, suffix: "Hz", rounding: .significantDigits)
        default:
            return NumberFormatter(digits: 2, multiplier: 0.001, suffix: "kHz", rounding: .significantDigits)
        }
    }
    
}

/// A parameter formatter class which just returns a custom fixed string value.
public struct StringParameterFormatter: ParameterFormatter {
    
    /// The formatter's string.
    public var string: String?
    
    public func string(for value: Float) -> String? {
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
    
    public func string(for value: Float) -> String? {
        return steps[value] ?? ""
    }

}

// MARK: - Private extensions

private extension NumberFormatter {
    
    enum Rounding {
        case fractionDigits
        case significantDigits
    }
    
    convenience init(digits: Int, multiplier: Float = 1, suffix: String? = nil, rounding: Rounding = .fractionDigits) {
        self.init()
        self.numberStyle = .decimal
        
        switch rounding {
        case .fractionDigits:
            self.usesSignificantDigits = false
            self.minimumFractionDigits = digits
            self.maximumFractionDigits = digits
            break
        case .significantDigits:
            self.usesSignificantDigits = true
            self.minimumSignificantDigits = digits
            self.maximumSignificantDigits = digits
            break
        }
        
        self.multiplier = NSNumber(value: multiplier)
        
        self.positiveSuffix = suffix
        self.negativeSuffix = suffix
    }
    
}
