//
//  Int+Parity.swift
//  VOWL
//
//  Created by Daniel Clelland on 19/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

extension Int {
    enum Parity {
        case Even
        case Odd
    }
    
    func parity() -> Parity {
        return self % 2 == 0 ? .Even : .Odd
    }
    
    func isEven() -> Bool {
        return self.parity() == .Even
    }
    
    func isOdd() -> Bool {
        return self.parity() == .Odd
    }
}