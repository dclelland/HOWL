//
//  KeyboardKey.swift
//  VOWL
//
//  Created by Daniel Clelland on 16/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class KeyboardKey {
    var pitch: Int
    var value: Float
    var location: CGPoint
    
    init(withPitch pitch: Int, value: Float, location: CGPoint) {
        self.pitch = pitch
        self.value = value
        self.location = location
    }
}

extension KeyboardKey {
    
    // MARK: - Drawing
    
    func numberOfPoints() -> Int {
        return self.shape() == .Diamond ? 4 : 3
    }
    
    func pointAtIndex(index: Int, forHitPathInBounds bounds: CGRect) -> CGPoint {
        let scale = CGAffineTransformMakeScale(bounds.width, bounds.height)
        let translation = CGAffineTransformMakeTranslation(bounds.minX, bounds.minY)
        
        let point = CGPointApplyAffineTransform(self.pointAtIndex(index), CGAffineTransformConcat(scale, translation))
        
        return CGPointMake(round(point.x), round(point.y))
    }
    
    func pointAtIndex(index: Int, forDrawPathInBounds bounds: CGRect) -> CGPoint {
        let point = self.pointAtIndex(index, forHitPathInBounds:bounds)
        let transform = self.transformAtIndex(index)
        
        return CGPointApplyAffineTransform(point, transform)
    }
    
    // MARK: - Shapes
    
    private enum Shape {
        case UpTriangle
        case DownTriangle
        case LeftTriangle
        case RightTriangle
        case Diamond
    }
    
    private func shape() -> Shape {
        if location.x <= 0.0 {
            return .RightTriangle
        }
        
        if location.x >= 1.0 {
            return .LeftTriangle
        }
        
        if location.y <= 0.0 {
            return .DownTriangle
        }
        
        if location.y >= 1.0 {
            return .UpTriangle
        }
        
        return .Diamond
    }
    
    // MARK: - Points
    
    private static let gutter: CGFloat = 2.0
    
    private func pointAtIndex(index: Int) -> CGPoint {
        switch self.shape() {
        case .Diamond:
            switch index {
            case 0: return CGPointMake(location.x, location.y - 1.0 / 6.0)
            case 1: return CGPointMake(location.x + 1.0 / 12.0, location.y)
            case 2: return CGPointMake(location.x, location.y + 1.0 / 6.0)
            case 3: return CGPointMake(location.x - 1.0 / 12.0, location.y)
            default: return CGPointZero
            }
        case .UpTriangle:
            switch index {
            case 0: return CGPointMake(location.x, location.y - 1.0 / 6.0)
            case 1: return CGPointMake(location.x + 1.0 / 12.0, location.y)
            case 2: return CGPointMake(location.x - 1.0 / 12.0, location.y)
            default: return CGPointZero
            }
        case .DownTriangle:
            switch index {
            case 0: return CGPointMake(location.x + 1.0 / 12.0, location.y)
            case 1: return CGPointMake(location.x, location.y + 1.0 / 6.0)
            case 2: return CGPointMake(location.x - 1.0 / 12.0, location.y)
            default: return CGPointZero
            }
        case .LeftTriangle:
            switch index {
            case 0: return CGPointMake(location.x, location.y - 1.0 / 6.0)
            case 1: return CGPointMake(location.x, location.y + 1.0 / 6.0)
            case 2: return CGPointMake(location.x - 1.0 / 12.0, location.y)
            default: return CGPointZero
            }
        case .RightTriangle:
            switch index {
            case 0: return CGPointMake(location.x, location.y - 1.0 / 6.0)
            case 1: return CGPointMake(location.x + 1.0 / 12.0, location.y)
            case 2: return CGPointMake(location.x, location.y + 1.0 / 6.0)
            default: return CGPointZero
            }
        }
    }
    
    private func transformAtIndex(index: Int) -> CGAffineTransform {
        switch self.shape() {
        case .Diamond:
            switch (index) {
            case 0: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * 0.5)
            case 1: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * -0.5, 0.0)
            case 2: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * -0.5)
            case 3: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * 0.5, 0.0)
            default: return CGAffineTransformIdentity
            }
        case .UpTriangle:
            switch (index) {
            case 0: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * 0.5)
            case 1: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * -0.5, 0.0)
            case 2: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * 0.5, 0.0)
            default: return CGAffineTransformIdentity
            }
        case .DownTriangle:
            switch (index) {
            case 0: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * -0.5, 0.0)
            case 1: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * -0.5)
            case 2: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * 0.5, 0.0)
            default: return CGAffineTransformIdentity
            }
        case .LeftTriangle:
            switch (index) {
            case 0: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * 0.5)
            case 1: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * -0.5)
            case 2: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * 0.5, 0.0)
            default: return CGAffineTransformIdentity
            }
        case .RightTriangle:
            switch (index) {
            case 0: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * 0.5)
            case 1: return CGAffineTransformMakeTranslation(KeyboardKey.gutter * -0.5, 0.0)
            case 2: return CGAffineTransformMakeTranslation(0.0, KeyboardKey.gutter * -0.5)
            default: return CGAffineTransformIdentity
            }
        }
    }
    
}
