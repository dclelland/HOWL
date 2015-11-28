//
//  Int+HOWL.swift
//  HOWL
//
//  Created by Daniel Clelland on 19/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: - Parity

extension Int {
    
    enum Parity {
        case Even
        case Odd
    }
    
    var parity: Parity {
        return self % 2 == 0 ? .Even : .Odd
    }
    
    var isEven: Bool {
        return parity == .Even
    }
    
    var isOdd: Bool {
        return parity == .Odd
    }
}