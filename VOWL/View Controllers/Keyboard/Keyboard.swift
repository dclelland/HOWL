//
//  Keyboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

struct KeyboardCoordinate {
    var leftAxis: Int
    var rightAxis: Int
    
    init(withLeftAxis leftAxis: Int, rightAxis: Int) {
        self.leftAxis = leftAxis
        self.rightAxis = rightAxis
    }
}

class Keyboard {
    
    var leftAxisInterval: Int = 4
    var rightAxisInterval: Int = 7
    
    var centerPitch: Int = 40
    
    func pitchForCoordinate(coordinate: KeyboardCoordinate) -> Int {
        return centerPitch + coordinate.leftAxis * leftAxisInterval + coordinate.rightAxis * rightAxisInterval
    }

}
