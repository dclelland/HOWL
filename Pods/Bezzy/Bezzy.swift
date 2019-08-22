//
//  Bezzy.swift
//  Bezzy
//
//  Created by Daniel Clelland on 6/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

#if os(iOS)
    
    public typealias BezierPath = UIBezierPath
    
    public typealias Point = CGPoint
    
    public typealias Rect = CGRect
    
#elseif os(OSX)
    
    public typealias BezierPath = NSBezierPath
    
    public typealias Point = NSPoint
    
    public typealias Rect = NSRect
    
#endif

// MARK: Initialization

public extension BezierPath {
    
    /// Initialize a new bezier path using a closure.
    convenience init(_ closure: (BezierPath) -> Void) {
        self.init()
        closure(self)
    }
    
    /// Create a new bezier path using a copy of an existing one and a closure.
    static func make(_ path: BezierPath, _ closure: (BezierPath) -> Void) -> BezierPath {
        let copy = path.copy() as! BezierPath
        closure(copy)
        return copy
    }
    
}

// MARK: - Enums

public extension BezierPath {
    
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
        
        /// Move the current point, adding a quadratic Bézier curve in the process.
        case quadCurve(p1: Point)
        
        /// Move the current point, adding a cubic Bézier curve in the process.
        case cubicCurve(p1: Point, p2: Point)
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
    
    /// Specifies an open or closed path.
    enum Path {
        
        /// An open path.
        case open
        
        /// A closed path.
        case closed
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

extension BezierPath {
    
    /// Add a movement to a location defined by `point`.
    public func add(_ movement: Movement, to point: Point) {
        #if os(iOS)
            switch movement {
            case .move:
                move(to: point)
            case .line:
                addLine(to: point)
            case .quadCurve(let p1):
                addQuadCurve(to: point, controlPoint: p1)
            case .cubicCurve(let p1, let p2):
                addCurve(to: point, controlPoint1: p1, controlPoint2: p2)
            }
        #elseif os(OSX)
            switch movement {
            case .move:
                move(to: point)
            case .line:
                line(to: point)
            case .quadCurve(let p1):
                curve(to: point, controlPoint1: p1, controlPoint2: p1)
            case .cubicCurve(let p1, let p2):
                curve(to: point, controlPoint1: p1, controlPoint2: p2)
            }
        #endif
    }
    
    /// Add a movement to the point defined by `x` and `y`.
    public func add(_ movement: Movement, x: CGFloat, y: CGFloat) {
        add(movement, to: Point(x: x, y: y))
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

extension BezierPath {
    
    /// Add a shape at a location defined by `rect`.
    public func add(_ shape: Shape, at rect: Rect) {
        #if os(iOS)
            switch shape {
            case .rect:
                append(UIBezierPath(rect: rect))
            case .oval:
                append(UIBezierPath(ovalIn: rect))
            case .roundedRect(let cornerRadius):
                append(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius))
            }
        #elseif os(OSX)
            switch shape {
            case .rect:
                append(BezierPath(rect: rect))
            case .oval:
                append(BezierPath(ovalIn: rect))
            case .roundedRect(let cornerRadius):
                append(BezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius))
            }
        #endif
    }
    
    /// Add a rect with `origin` and `size`.
    public func add(_ shape: Shape, origin: Point, size: CGSize) {
        add(shape, at: Rect(origin: origin, size: size))
    }
    
    /// Add a rect with `x`, `y`, `width` and `height`.
    public func add(_ shape: Shape, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        add(shape, at: Rect(x: x, y: y, width: width, height: height))
    }
    
    /// Add a rect with `center` and `radius`.
    public func add(_ shape: Shape, center: Point, radius: CGFloat) {
        add(shape, x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
    
    /// Add a rect with `center` and `size`.
    public func add(_ shape: Shape, center: Point, size: CGSize) {
        add(shape, x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
}

// MARK: - Paths

extension BezierPath {
    
    /// Add a list of points as a path.
    public func add(_ path: Path, points: [Point]) {
        let head = points.first
        let tail = points.suffix(from: 1)
        
        if let head = head {
            add(.move, to: head)
        }
        
        for point in tail {
            add(.line, to: point)
        }
        
        if path == .closed {
            close()
        }
    }
    
}

// MARK: - Translate

extension BezierPath {
    
    /// Translate the path rightwards by `tx` and downwards by `ty`.
    public func translate(tx: CGFloat, ty: CGFloat) {
        #if os(iOS)
            apply(CGAffineTransform(translationX: tx, y: ty))
        #elseif os(OSX)
            transform(using: AffineTransform(translationByX: tx, byY: ty))
        #endif
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

extension BezierPath {
    
    /// Scales the path horizontally by `sx` and vertically by `sy`.
    public func scale(sx: CGFloat, sy: CGFloat) {
        #if os(iOS)
            apply(CGAffineTransform(scaleX: sx, y: sy))
        #elseif os(OSX)
            transform(using: AffineTransform(scaleByX: sx, byY: sy))
        #endif
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

extension BezierPath {
    
    /// Rotate the path in the specified directional `motion` for `angle` (radians).
    public func rotate(_ angle: CGFloat, _ motion: Motion = .clockwise) {
        #if os(iOS)
            switch motion {
            case .clockwise:
                apply(CGAffineTransform(rotationAngle: angle))
            case .anticlockwise:
                apply(CGAffineTransform(rotationAngle: -angle))
            }
        #elseif os(OSX)
            switch motion {
            case .clockwise:
                transform(using: AffineTransform(rotationByRadians: angle))
            case .anticlockwise:
                transform(using: AffineTransform(rotationByRadians: angle))
            }
        #endif
    }
    
}
