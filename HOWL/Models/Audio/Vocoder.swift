//
//  Vocoder.swift
//  HOWL
//
//  Created by Daniel Clelland on 3/07/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import AudioKit
import Lerp
import Persistable

class Vocoder: AKNode {
    
    // MARK: - Properties
    
    var xIn = Persistent(value: 0.5, key: "vocoderXIn") {
        didSet {
            filterBank.setValue(value: xIn.value, forParameter: .XIn)
        }
    }
    
    var yIn = Persistent(value: 0.5, key: "vocoderYIn") {
        didSet {
            filterBank.setValue(value: yIn.value, forParameter: .YIn)
        }
    }
    
    var xOut: Double {
        return filterBank.value(forParameter: .XOut)
    }
    
    var yOut: Double {
        return filterBank.value(forParameter: .YOut)
    }
    
    var lfoXShape = Persistent(value: 0.25, key: "vocoderLfoXShape") {
        didSet {
            filterBank.setValue(value: lfoXShape.value, forParameter: .LfoXShape)
        }
    }
    
    var lfoXDepth = Persistent(value: 0.0, key: "vocoderLfoXDepth") {
        didSet {
            filterBank.setValue(value: lfoXDepth.value, forParameter: .LfoXDepth)
        }
    }
    
    var lfoXRate = Persistent(value: 0.0, key: "vocoderLfoXRate") {
        didSet {
            filterBank.setValue(value: lfoXRate.value, forParameter: .LfoXRate)
        }
    }
    
    var lfoYShape = Persistent(value: 0.25, key: "vocoderLfoYShape") {
        didSet {
            filterBank.setValue(value: lfoXShape.value, forParameter: .LfoXShape)
        }
    }
    
    var lfoYDepth = Persistent(value: 0.0, key: "vocoderLfoYDepth") {
        didSet {
            filterBank.setValue(value: lfoYDepth.value, forParameter: .LfoYDepth)
        }
    }
    
    var lfoYRate = Persistent(value: 0.0, key: "vocoderLfoYRate") {
        didSet {
            filterBank.setValue(value: lfoYRate.value, forParameter: .LfoYRate)
        }
    }
    
    var formantsFrequency = Persistent(value: 1.0, key: "vocoderFormantsFrequency") {
        didSet {
            filterBank.setValue(value: formantsFrequency.value, forParameter: .FormantsFrequency)
        }
    }
    
    var formantsBandwidth = Persistent(value: 1.0, key: "vocoderFormantsBandwidth") {
        didSet {
            filterBank.setValue(value: formantsBandwidth.value, forParameter: .FormantsBandwidth)
        }
    }
    
    // MARK: - Special properties
    
    var location: CGPoint {
        get {
            return CGPoint(x: xIn.value, y: yIn.value)
        }
        set {
            xIn.value = Double(newValue.x)
            yIn.value = Double(newValue.y)
        }
    }
    
    // MARK: - Nodes
    
    fileprivate let mixer: AKMixer
    
    fileprivate let filterBank: FilterBank
    
    fileprivate let balancer: AKBalancer
    
    // MARK: - Initialization
    
    init(withInput input: AKNode) {
        self.mixer = AKMixer(input)
        self.mixer.stop()
        
        self.filterBank = FilterBank(
            self.mixer,
            xIn: self.xIn.value,
            yIn: self.yIn.value,
            lfoXShape: self.lfoXShape.value,
            lfoXDepth: self.lfoXDepth.value,
            lfoXRate: self.lfoXRate.value,
            lfoYShape: self.lfoYShape.value,
            lfoYDepth: self.lfoYDepth.value,
            lfoYRate: self.lfoYRate.value,
            formantsFrequency: self.formantsFrequency.value,
            formantsBandwidth: self.formantsBandwidth.value
        )
        
        self.balancer = AKBalancer(self.filterBank, comparator: self.mixer)
        
        super.init()
        
        self.avAudioNode = self.balancer.avAudioNode
        input.addConnectionPoint(self.mixer)
    }

}

// MARK: - Toggleable

extension Vocoder: AKToggleable {
    
    var isStarted: Bool {
        return mixer.isStarted
    }
    
    func start() {
        mixer.start()
    }
    
    func stop() {
        mixer.stop()
    }
    
}

// MARK: - Filter bank

private class FilterBank: AKOperationEffect {
    
    enum Parameter: Int {
        case XIn
        case YIn
        case XOut
        case YOut
        case LfoXShape
        case LfoXDepth
        case LfoXRate
        case LfoYShape
        case LfoYDepth
        case LfoYRate
        case FormantsFrequency
        case FormantsBandwidth
    }

    convenience init(
        _ input: AKNode,
          xIn: Double,
          yIn: Double,
          lfoXShape: Double,
          lfoXDepth: Double,
          lfoXRate: Double,
          lfoYShape: Double,
          lfoYDepth: Double,
          lfoYRate: Double,
          formantsFrequency: Double,
          formantsBandwidth: Double
        ) {
        
//        let xInParameter = AKOperation.parameters(Parameter.XIn.rawValue)
//        let yInParameter = AKOperation.parameters(Parameter.YIn.rawValue)
//        
//        let xOutParameter = AKOperation.parameters(Parameter.XOut.rawValue)
//        let yOutParameter = AKOperation.parameters(Parameter.YOut.rawValue)
//        
//        let lfoXShapeParameter = AKOperation.parameters(Parameter.LfoXShape.rawValue)
//        let lfoXDepthParameter = AKOperation.parameters(Parameter.LfoXDepth.rawValue)
//        let lfoXRateParameter = AKOperation.parameters(Parameter.LfoXRate.rawValue)
//        
//        let lfoYShapeParameter = AKOperation.parameters(Parameter.LfoYShape.rawValue)
//        let lfoYDepthParameter = AKOperation.parameters(Parameter.LfoYDepth.rawValue)
//        let lfoYRateParameter = AKOperation.parameters(Parameter.LfoYRate.rawValue)
//        
//        let formantsFrequencyParameter = AKOperation.parameters(Parameter.FormantsFrequency.rawValue) + 0.01
//        let formantsBandwidthParameter = AKOperation.parameters(Parameter.FormantsBandwidth.rawValue) + 0.01
//        
//        let sporth = "((\(lfoXRateParameter) (\(lfoXDepthParameter) 0.5 *) sine) \(xInParameter) +) \(Parameter.XOut.rawValue) pset" ++
//                     "((\(lfoYRateParameter) (\(lfoYDepthParameter) 0.5 *) sine) \(yInParameter) +) \(Parameter.YOut.rawValue) pset" ++
//                     "" ++
//                     "'frequencies' 4 zeros" ++
//                     "" ++
//                     "(\(yOutParameter) (\(xOutParameter) 844.0 768.0 scale) (\(xOutParameter) 324.0 378.0 scale) scale) 0 'frequencies' tset" ++
//                     "(\(yOutParameter) (\(xOutParameter) 1656.0 1333.0 scale) (\(xOutParameter) 2985.0 997.0 scale) scale) 1 'frequencies' tset" ++
//                     "(\(yOutParameter) (\(xOutParameter) 2437.0 2522.0 scale) (\(xOutParameter) 3329.0 2343.0 scale) scale) 2 'frequencies' tset" ++
//                     "(\(yOutParameter) (\(xOutParameter) 3704.0 3687.0 scale) (\(xOutParameter) 3807.0 3357.0 scale) scale) 3 'frequencies' tset" ++
//                     "" ++
//                     "\(AKOperation.input)" ++
//                     "(((0 'frequencies' tget) \(formantsFrequencyParameter) *) 0.02 port) (((dup 0.02 *) 50.0 +) \(formantsBandwidthParameter) *) reson" ++
//                     "(((1 'frequencies' tget) \(formantsFrequencyParameter) *) 0.02 port) (((dup 0.02 *) 50.0 +) \(formantsBandwidthParameter) *) reson" ++
//                     "(((2 'frequencies' tget) \(formantsFrequencyParameter) *) 0.02 port) (((dup 0.02 *) 50.0 +) \(formantsBandwidthParameter) *) reson" ++
//                     "(((3 'frequencies' tget) \(formantsFrequencyParameter) *) 0.02 port) (((dup 0.02 *) 50.0 +) \(formantsBandwidthParameter) *) reson" ++
//                     "dup"
//        
//        self.init(input, sporth: sporth)
        self.init(input, sporth: "")
        self.parameters = [
            xIn,
            yIn,
            xIn,
            yIn,
            lfoXShape,
            lfoXDepth,
            lfoXRate,
            lfoYShape,
            lfoYDepth,
            lfoYRate,
            formantsFrequency,
            formantsBandwidth
        ]
    }
    
    // MARK: - Parameters
    
    func setValue(value: Double, forParameter parameter: Parameter) {
        parameters[parameter.rawValue] = value
    }
    
    func value(forParameter parameter: Parameter) -> Double {
        return parameters[parameter.rawValue]
    }
    
}

// MARK: - Private operators

infix operator ++ : AdditionPrecedence

private func ++ (left: String, right: String) -> String {
    return left + "\n" + right
}
