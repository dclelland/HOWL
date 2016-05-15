//
//  ParameterScale.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation
import Lerp

/// A protocol which describes a two-way conversion between a ratio in range `0.0...`1.0` and useful values.
protocol ParameterScale {
    
    /// Converts a ratio in range `0.0...1.0` to a useful value.
    func value(forRatio ratio: Float) -> Float
    
    /// Converts a value to a ratio in range `0.0...1.0`.
    func ratio(forValue value: Float) -> Float
    
}

/// A scale describing a linear conversion. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`.
/// For example, if `minimum` is `2.0` and `maximum` is `4.0`, then a *ratio* of `0.5` will be converted to a *value* of `3.0`.
/// Ratios out of bounds are truncated.
struct LinearParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Float
    
    /// The scale's maximum value.
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return value.ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
    }
    
}

/// A scale describing a logarithmic conversion. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`, taking the value to the power of *e* before the conversion.
/// This results in a scale with a subtle gradient at the start, but a dramatic gradient near the end. This is most useful if you would like your control to cover multiple orders of magnitude.
/// Ratios out of bounds are truncated.
struct LogarithmicParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Float
    
    /// The scale's maximum value.
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return pow(ratio.clamp(min: 0.0, max: 1.0), Float(M_E)).lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return pow(value.ilerp(min: minimum, max: maximum), 1.0 / Float(M_E)).clamp(min: 0.0, max: 1.0)
    }
    
}

/// A scale describing a linear conversion including a rounding process. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`, rounding after conversion.
/// For example, if `minimum` is `2.0` and `maximum` is `4.0`, then a *ratio* of `0.6` will be first converted to a *value* of `3.2`, then *rounded* to `3.0`.
/// Ratios out of bounds are truncated.
struct IntegerParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Float
    
    /// The scale's maximum value.
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return round(ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum))
    }
    
    func ratio(forValue value: Float) -> Float {
        return round(value).ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
    }

}

/// A scale describing a conversion via picking from a stepped sequence. A ratio in range `0.0...1.0` is first converted to an index in range `0..<values.count`, before being used to pick a value from `values`.
/// For example, if `values` is `[0.5, 1.0, 1.5, 2.0]`, then a ratio of `0.6` will first be converted to an unrounded index of `1.8`, before being rounded to the integer `2`, which will return the value `1.5`.
///
/// Invalid ratios or values will return zero, in the interest of type safety but at the disregard of sensible behaviour (we'd rather return `0.0` than crash in the event some process causes an invalid value to be sent here at run time).
///
/// Values must also be unique, in the interest of transitivity.
struct SteppedParameterScale: ParameterScale {
    
    /// The scale's list of value steps.
    var values: [Float]
    
    func value(forRatio ratio: Float) -> Float {
        return value(forIndex: index(forRatio: ratio))
    }
    
    func ratio(forValue value: Float) -> Float {
        return ratio(forIndex: index(forValue: value))
    }
    
    // MARK: Ratio to index to value
    
    private func index(forRatio ratio: Float) -> Int {
        return Int(round(ratio * Float(values.count - 1)))
    }
    
    private func value(forIndex index: Int) -> Float {
        if (values.indices.contains(index)) {
            return values[index]
        } else {
            return 0.0
        }
    }
    
    // MARK: Value to index to ratio
    
    private func index(forValue value: Float) -> Int {
        return values.indexOf(value) ?? 0
    }
    
    private func ratio(forIndex index: Int) -> Float {
        return Float(index) / Float(values.count - 1)
    }
    
}
