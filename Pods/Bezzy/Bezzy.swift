//
//  Bezzy.swift
//  Bezzy
//
//  Created by Daniel Clelland on 6/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation

public extension UIBezierPath {
    
    /**
     Creates a new bezier path, using a `PathMaker` class.
     
     - parameter closure: The *closure*, used to apply operations to the `PathMaker` instance.
     
     - returns: The new bezier path.
     */
    
    class func makePath(@noescape closure: (make: PathMaker) -> Void) -> UIBezierPath {
        let maker = PathMaker(path: UIBezierPath())
        closure(make: maker)
        return maker.path
    }
    
    /**
     Creates a new bezier path, using a `PathMaker` class, starting with a copy of `self`.
     
     - parameter closure: The *closure*, used to apply operations to the `PathMaker` instance.
     
     - returns: The new bezier path.
     */
    
    func makePath(@noescape closure: (make: PathMaker) -> Void) -> UIBezierPath {
        let maker = PathMaker(path: self.copy() as! UIBezierPath)
        closure(make: maker)
        return maker.path
    }
    
}

public class PathMaker {
    
    private let path: UIBezierPath
    
    private init(path: UIBezierPath) {
        self.path = path
    }
    
}

public extension PathMaker {
    
    // MARK: Moves
    
    /// Move the current point to `point`.
    public func move(point: CGPoint) -> PathMaker {
        path.moveToPoint(point)
        return self
    }
    
    /// Move the current point to the point defined by `x` and `y`.
    public func move(x x: CGFloat, y: CGFloat) -> PathMaker {
        return move(CGPoint(x: x, y: y))
    }
    
    /// Move the current point by the vector defined by `dx` and `dy`.
    public func move(dx dx: CGFloat, dy: CGFloat) -> PathMaker {
        return move(x: path.currentPoint.x + dx, y: path.currentPoint.y + dy)
    }
    
    /// Move the current point by amount `distance` in the specified `direction` (radians)
    public func move(distance: CGFloat, direction: CGFloat) -> PathMaker {
        return move(dx: distance * cos(direction), dy: distance * sin(direction))
    }
    
    /// Move the current point upwards by amount `distance`.
    public func move(up distance: CGFloat) -> PathMaker {
        return move(dx: 0, dy: -distance)
    }
    
    /// Move the current point leftwards by amount `distance`.
    public func move(left distance: CGFloat) -> PathMaker {
        return move(dx: -distance, dy: 0)
    }
    
    /// Move the current point downwards by amount `distance`.
    public func move(down distance: CGFloat) -> PathMaker {
        return move(dx: 0, dy: distance)
    }
    
    /// Move the current point rightwards by amount `distance`.
    public func move(right distance: CGFloat) -> PathMaker {
        return move(dx: distance, dy: 0)
    }
    
}

public extension PathMaker {
    
    // MARK: Lines
    
    /// Append a line to `point`.
    public func line(point: CGPoint) -> PathMaker {
        path.addLineToPoint(point)
        return self
    }
    
    /// Append a line to the point defined by `x` and `y`.
    public func line(x x: CGFloat, y: CGFloat) -> PathMaker {
        return line(CGPointMake(x, y))
    }
    
    /// Append a line defined by the vector defined by `dx` and `dy`.
    public func line(dx dx: CGFloat, dy: CGFloat) -> PathMaker {
        return line(x: path.currentPoint.x + dx, y: path.currentPoint.y + dy)
    }
    
    /// Append a line by amount `distance` in the specified `direction` (radians)
    public func line(distance: CGFloat, direction: CGFloat) -> PathMaker {
        return line(dx: distance * cos(direction), dy: distance * sin(direction))
    }
    
    /// Append a line upwards by amount `distance`.
    public func line(up distance: CGFloat) -> PathMaker {
        return line(dx: 0, dy: -distance)
    }
    
    /// Append a line leftwards by amount `distance`.
    public func line(left distance: CGFloat) -> PathMaker {
        return line(dx: -distance, dy: 0)
    }
    
    /// Append a line downwards by amount `distance`.
    public func line(down distance: CGFloat) -> PathMaker {
        return line(dx: 0, dy: distance)
    }
    
    /// Append a line rightwards by amount `distance`.
    public func line(right distance: CGFloat) -> PathMaker {
        return line(dx: distance, dy: 0)
    }
    
}

public extension PathMaker {
    
    // MARK: Arcs
    
    /// Append an arc around `center` with specified `radius`, `startAngle` (radians), `endAngle` (radians), and `clockwise` flag
    public func arc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> PathMaker {
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return self
    }
    
}

public extension PathMaker {

    // MARK: Curves
    
    /// Append a cubic bézier to `point`, using `controlPoint1` and `controlPoint2`.
    public func curve(point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) -> PathMaker {
        path.addCurveToPoint(point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        return self
    }
}

public extension PathMaker {
    
    // MARK: Quad curves
    
    /// Append a quadratic bézier to `point`, using `controlPoint`.
    public func quadCurve(point: CGPoint, controlPoint: CGPoint) -> PathMaker {
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        return self
    }
}

public extension PathMaker {
    
    // MARK: Paths
    
    /// Appends `path` to the path.
    public func path(path: UIBezierPath) -> PathMaker {
        path.appendPath(path)
        return self
    }
    
}

public extension PathMaker {
    
    // MARK: Rects
    
    /// Appends a rectangular path with `rect` to the path.
    public func rect(rect: CGRect) -> PathMaker {
        path.appendPath(UIBezierPath(rect: rect))
        return self
    }
    
    /// Appends a rectangular path with `origin` and `size` to the path.
    public func rect(origin origin: CGPoint, size: CGSize) -> PathMaker {
        return rect(CGRect(origin: origin, size: size))
    }
    
    /// Appends a rectangular path with `x`, `y`, `width` and `height` to the path.
    public func rect(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PathMaker {
        return rect(CGRect(x: x, y: y, width: width, height: height))
    }
    
    /// Appends a rectangular path with `center` and `radius` to the path.
    public func rect(at center: CGPoint, radius: CGFloat) -> PathMaker {
        return rect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
    
    /// Appends a rectangular path with `center` and `size` to the path.
    public func rect(at center: CGPoint, size: CGSize) -> PathMaker {
        return rect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
}

public extension PathMaker {
    
    // MARK: Ovals
    
    /// Appends an ellipsoid path with `rect` to the path.
    public func oval(rect: CGRect) -> PathMaker {
        path.appendPath(UIBezierPath(ovalInRect: rect))
        return self
    }
    
    /// Appends an ellipsoid path with `origin` and `size` to the path.
    public func oval(origin origin: CGPoint, size: CGSize) -> PathMaker {
        return oval(CGRect(origin: origin, size: size))
    }
    
    /// Appends an ellipsoid path with `x`, `y`, `width` and `height` to the path.
    public func oval(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PathMaker {
        return oval(CGRect(x: x, y: y, width: width, height: height))
    }
    
    /// Appends an ellipsoid path with `center` and `radius` to the path.
    public func oval(at center: CGPoint, radius: CGFloat) -> PathMaker {
        return oval(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
    
    /// Appends an ellipsoid path with `center` and `size` to the path.
    public func oval(at center: CGPoint, size: CGSize) -> PathMaker {
        return oval(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
}

public extension PathMaker {
    
    // MARK: Rounded rects
    
    /// Appends a rounded rectangular path with `rect` and `cornerRadius` to the path.
    public func roundedRect(rect: CGRect, cornerRadius: CGFloat) -> PathMaker {
        path.appendPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius))
        return self
    }
    
    /// Appends a rounded rectangular path with `origin`, `size` and `cornerRadius` to the path.
    public func roundedRect(origin origin: CGPoint, size: CGSize, cornerRadius: CGFloat) -> PathMaker {
        return roundedRect(CGRect(origin: origin, size: size), cornerRadius: cornerRadius)
    }
    
    /// Appends a rounded rectangular path with `x`, `y`, `width`, `height` and `cornerRadius` to the path.
    public func roundedRect(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) -> PathMaker {
        return roundedRect(CGRect(x: x, y: y, width: width, height: height), cornerRadius: cornerRadius)
    }
    
    /// Appends a rounded rectangular path with `center`, `radius` and `cornerRadius` to the path.
    public func roundedRect(at center: CGPoint, radius: CGFloat, cornerRadius: CGFloat) -> PathMaker {
        return roundedRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2, cornerRadius: cornerRadius)
    }
    
    /// Appends a rounded rectangular path with `center` and `size` and `cornerRadius` to the path.
    public func roundedRect(at center: CGPoint, size: CGSize, cornerRadius: CGFloat) -> PathMaker {
        return roundedRect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height, cornerRadius: cornerRadius)
    }
    
}

public extension PathMaker {
    
    // MARK: Transforms
    
    /// Apply `transform` to the path.
    public func transform(transform: CGAffineTransform) -> PathMaker {
        path.applyTransform(transform)
        return self
    }
    
    // MARK: Translations
    
    /// Translate the path by the vector defined by `tx` and rightwards by `ty`.
    public func translation(tx tx: CGFloat, ty: CGFloat) -> PathMaker {
        return transform(CGAffineTransformMakeTranslation(tx, ty))
    }
    
    /// Translate the path upwards by amount `distance`.
    public func translation(up distance: CGFloat) -> PathMaker {
        return translation(tx: 0, ty: -distance)
    }
    
    /// Translate the path leftwards by amount `distance`.
    public func translation(left distance: CGFloat) -> PathMaker {
        return translation(tx: -distance, ty: 0)
    }
    
    /// Translate the path downwards by amount `distance`.
    public func translation(down distance: CGFloat) -> PathMaker {
        return translation(tx: 0, ty: distance)
    }
    
    /// Translate the path rightwards by amount `distance`.
    public func translation(right distance: CGFloat) -> PathMaker {
        return translation(tx: distance, ty: 0)
    }
    
    // MARK: Scaling
    
    /// Scales the path horizontally by `sx` and vertically by `sy`.
    public func scale(sx sx: CGFloat, sy: CGFloat) -> PathMaker {
        return transform(CGAffineTransformMakeScale(sx, sy))
    }
    
    /// Scales the path horizontally by amount `ratio`.
    public func scale(horizontally ratio: CGFloat) -> PathMaker {
        return scale(sx: ratio, sy: 0)
    }
    
    /// Scales the path vertically by amount `ratio`.
    public func scale(vertically ratio: CGFloat) -> PathMaker {
        return scale(sx: 0, sy: ratio)
    }
    
    // MARK: Rotation
    
    /// Rotates the path by amount `angle` (radians).
    public func rotation(angle: CGFloat) -> PathMaker {
        return transform(CGAffineTransformMakeRotation(angle))
    }
    
    /// Rotates the path clockwise by amount `angle` (radians).
    public func rotation(clockwise angle: CGFloat) -> PathMaker {
        return rotation(angle)
    }
    
    /// Rotates the path anticlockwise by amount `angle` (radians).
    public func rotation(anticlockwise angle: CGFloat) -> PathMaker {
        return rotation(-angle)
    }
}

public extension PathMaker {
    
    // MARK: Closure
    
    /// Close the path.
    public func close() -> PathMaker {
        self.path.closePath()
        return self
    }
    
    /// Close the path (alias of `close()`).
    public func closed() -> PathMaker {
        return self.close()
    }
}
