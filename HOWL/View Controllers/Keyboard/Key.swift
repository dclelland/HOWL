//
//  Key.swift
//  HOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

struct KeyCoordinates {
    var left: Int
    var right: Int
}

extension KeyCoordinates: Equatable {}

func ==(lhs: KeyCoordinates, rhs: KeyCoordinates) -> Bool {
    return lhs.left == rhs.left && lhs.right == rhs.right
}

struct Key {
    var pitch: Pitch
    var path: UIBezierPath
    var coordinates: KeyCoordinates
}

extension Key: Equatable {}

func ==(lhs: Key, rhs: Key) -> Bool {
    return lhs.pitch == rhs.pitch && lhs.coordinates == rhs.coordinates
}
