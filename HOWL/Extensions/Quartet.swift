//
//  Quartet.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

import Foundation

struct Quartet<T> {
    
    private var elements: (T, T, T, T)
    
    init(_ first: T, _ second: T, _ third: T, _ fourth: T) {
        self.elements = (first, second, third, fourth)
    }
    
    init(_ elements: [T]) {
        assert(elements.count == 4, "Number of elements (\(elements.count)) should equal 4")
        self.elements = (elements[0], elements[1], elements[2], elements[3])
    }
    
}

extension Quartet: ArrayLiteralConvertible {
    
    init(arrayLiteral elements: T...) {
        self.init(elements)
    }
    
}

extension Quartet: CollectionType {
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return 4
    }
    
    subscript(position: Int) -> T {
        get {
            switch position {
            case 0:
                return elements.0
            case 1:
                return elements.1
            case 2:
                return elements.2
            case 3:
                return elements.3
            default:
                fatalError("Element out of bounds")
            }
        }
    }
    
}

func + (left: Quartet<Float>, right: Quartet<Float>) -> Quartet<Float> {
    return Quartet(left.enumerate().map { $1 + right[$0] })
}

func + (left: Quartet<Float>, right: Float) -> Quartet<Float> {
    return Quartet(left.map { $0 + right })
}

func - (left: Quartet<Float>, right: Quartet<Float>) -> Quartet<Float> {
    return Quartet(left.enumerate().map { $1 - right[$0] })
}

func - (left: Quartet<Float>, right: Float) -> Quartet<Float> {
    return Quartet(left.map { $0 - right })
}

func * (left: Quartet<Float>, right: Quartet<Float>) -> Quartet<Float> {
    return Quartet(left.enumerate().map { $1 * right[$0] })
}

func * (left: Quartet<Float>, right: Float) -> Quartet<Float> {
    return Quartet(left.map { $0 * right })
}

func / (left: Quartet<Float>, right: Quartet<Float>) -> Quartet<Float> {
    return Quartet(left.enumerate().map { $1 / right[$0] })
}

func / (left: Quartet<Float>, right: Float) -> Quartet<Float> {
    return Quartet(left.map { $0 / right })
}
