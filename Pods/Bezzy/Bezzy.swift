//
//  Bezzy.swift
//  Bezzy
//
//  Created by Daniel Clelland on 6/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Initialization

public extension UIBezierPath {
    
    /// Initialize a new bezier path using a closure.
    convenience init(_ closure: (UIBezierPath) -> Void) {
        self.init()
        closure(self)
    }
    
    /// Create a new bezier path using a copy of an existing one and a closure.
    static func make(_ path: UIBezierPath, _ closure: (UIBezierPath) -> Void) -> UIBezierPath {
        let copy = path.copy() as! UIBezierPath
        closure(copy)
        return copy
    }
    
}

// MARK: - Enums

public extension UIBezierPath {
    
    /// Specifies a path operation in a given direction.
    enum Direction {
        
        /// An upwards operation.
        case up
        
        /// A leftwards operation.
        case left
        
        /// A downwards operation.
        case down
        
        /// A rightwards operation.
        case right
    }
    
    /// Specifies a type of path movement that can be appended to a path with a given point.
    enum Movement {
        
        /// Move the current point without adding a line.
        case move
        
        /// Move the current point, adding a line in the process.
        case line
    }
    
    /// Specifies a type of shape that can be appended to a path at a given rect.
    enum Shape {
        
        /// A rectangle.
        case rect
        
        /// An oval.
        case oval
        
        /// A rounded rectangle with given `cornerRadius`.
        case roundedRect(cornerRadius: CGFloat)
    }
    
    /// Specifies a path operation along a given axis.
    enum Axis {
        
        /// The horizontal axis.
        case horizontal
        
        /// The vertical axis.
        case vertical
    }
    
    
    /// Specifies a rotational direction.
    enum Motion {
        
        /// Rotate clockwise.
        case clockwise
        
        /// Rotate anticlockwise.
        case anticlockwise
    }

}

// MARK: - Movement

public extension UIBezierPath {
    
    /// Add a movement to a location defined by `point`.
    public func add(_ movement: Movement, to point: CGPoint) {
        switch movement {
        case .move:
            move(to: point)
        case .line:
            addLine(to: point)
        }
    }
    
    /// Add a movement to the point defined by `x` and `y`.
    public func add(_ movement: Movement, x: CGFloat, y: CGFloat) {
        add(movement, to: CGPoint(x: x, y: y))
    }
    
    /// Add a movement by the vector defined by `dx` and `dy`.
    public func add(_ movement: Movement, dx: CGFloat, dy: CGFloat) {
        add(movement, x: currentPoint.x + dx, y: currentPoint.y + dy)
    }
    
    /// Add a movement by the polar coordinates defined by `r` and `θ`.
    public func add(_ movement: Movement, r: CGFloat, θ: CGFloat) {
        add(movement, dx: r * cos(θ), dy: r * sin(θ))
    }
    
    /// Add a movement by an amount in the specified direction.
    public func add(_ movement: Movement, _ r: CGFloat, _ direction: Direction) {
        switch direction {
        case .up:
            add(movement, dx: 0, dy: -r)
        case .left:
            add(movement, dx: -r, dy: 0)
        case .down:
            add(movement, dx: 0, dy: r)
        case .right:
            add(movement, dx: r, dy: 0)
        }
    }
    
}

// MARK: - Shape

public extension UIBezierPath {
    
    /// Add a shape at a location defined by `rect`.
    public func add(_ shape: Shape, at rect: CGRect) {
        switch shape {
        case .rect:
            append(UIBezierPath(rect: rect))
        case .oval:
            append(UIBezierPath(ovalIn: rect))
        case .roundedRect(let cornerRadius):
            append(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius))
        }
    }
    
    /// Add a rect with `origin` and `size`.
    public func add(_ shape: Shape, origin: CGPoint, size: CGSize) {
        return add(shape, at: CGRect(origin: origin, size: size))
    }
    
    /// Add a rect with `x`, `y`, `width` and `height`.
    public func add(_ shape: Shape, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        return add(shape, at: CGRect(x: x, y: y, width: width, height: height))
    }
    
    /// Add a rect with `center` and `radius`.
    public func add(_ shape: Shape, center: CGPoint, radius: CGFloat) {
        return add(shape, x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
    
    /// Add a rect with `center` and `size`.
    public func add(_ shape: Shape, center: CGPoint, size: CGSize) {
        return add(shape, x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
}

// MARK: - Translate

public extension UIBezierPath {
    
    /// Translate the path rightwards by `tx` and downwards by `ty`.
    public func translate(tx: CGFloat, ty: CGFloat) {
        apply(CGAffineTransform(translationX: tx, y: ty))
    }
    
    /// Translate the path by the polar coordinates defined by `r` and `θ`.
    public func translate(r: CGFloat, θ: CGFloat) {
        translate(tx: r * cos(θ), ty: r * sin(θ))
    }
    
    /// Translate the path by an amount in the specified direction.
    public func translate(_ r: CGFloat, _ direction: Direction) {
        switch direction {
        case .up:
            translate(tx: 0, ty: -r)
        case .left:
            translate(tx: -r, ty: 0)
        case .down:
            translate(tx: 0, ty: r)
        case .right:
            translate(tx: r, ty: 0)
        }
    }
    
}

// MARK: - Scale

public extension UIBezierPath {
    
    /// Scales the path horizontally by `sx` and vertically by `sy`.
    public func scale(sx: CGFloat, sy: CGFloat) {
        return apply(CGAffineTransform(scaleX: sx, y: sy))
    }
    
    /// Scales the path along the specified `axis` by `ratio`.
    public func scale(_ ratio: CGFloat, _ axis: Axis) {
        switch axis {
        case .horizontal:
            scale(sx: ratio, sy: 0)
        case .vertical:
            scale(sx: 0, sy: ratio)
        }
    }
    
}

// MARK: - Rotate

public extension UIBezierPath {
    
    /// Rotate the path in the specified directional `motion` for `angle` (radians).
    public func rotate(_ angle: CGFloat, _ motion: Motion = .clockwise) {
        switch motion {
        case .clockwise:
            apply(CGAffineTransform(rotationAngle: angle))
        case .anticlockwise:
            apply(CGAffineTransform(rotationAngle: -angle))
        }
    }
    
}
