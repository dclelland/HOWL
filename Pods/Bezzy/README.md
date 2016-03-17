# Bezzy

Bezzy provides a simple way to build bézier paths using a psuedo-DSL.

Inspired by [SnapKit](https://github.com/SnapKit/SnapKit) and [TurtleBezierPath](https://github.com/mindbrix/TurtleBezierPath). Swift port of my [UIBezierPath+DSL](https://github.com/dclelland/UIBezierPath-DSL) Cocoapod.

✓ Supports relative positioning.

```swift
let path = UIBezierPath.makePath { make in
    make.move(x: 0.5, y: 0.5)
    make.line(up: 0.5)
    make.line(right: 0.5)
    make.line(down: 0.5)
    make.line(left: 1.0)
    make.line(down: 0.5)
    make.line(right: 0.5)
    make.closed()
}
```

✓ Supports transformations.

```swift
let path = UIBezierPath.makePath { make in
    make.oval(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    make.scale(sx: 20.0, sy: 20.0)
    make.translation(tx: 10.0, ty: 10.0)
}
```

✓ Supports function chaining.

```swift
let path = UIBezierPath.makePath { make in
    make.move(x: 0.0, y: 0.5).line(x: 0.5, y: 0.0).line(x: 1.0, y: 0.5).line(x: 0.5, y: 1.0).close()
}
```

### Full API:

UIBezierPath

```swift
// Constructors
class func makePath(closure: (make: PathMaker) -> Void) -> UIBezierPath
func makePath(closure: (make: PathMaker) -> Void) -> UIBezierPath
```

PathMaker

```swift
// Moves
func move(point: CGPoint)
func move(x x: CGFloat, y: CGFloat)
func move(dx dx: CGFloat, dy: CGFloat)
func move(distance: CGFloat, direction: CGFloat)
func move(up distance: CGFloat)
func move(left distance: CGFloat)
func move(down distance: CGFloat)
func move(right distance: CGFloat)

// Lines
func line(point: CGPoint)
func line(x x: CGFloat, y: CGFloat)
func line(dx dx: CGFloat, dy: CGFloat)
func line(distance: CGFloat, direction: CGFloat)
func line(up distance: CGFloat)
func line(left distance: CGFloat)
func line(down distance: CGFloat)
func line(right distance: CGFloat)

// Arcs
func arc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)

// Curves
func curve(point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)

// Quad curves
func quadCurve(point: CGPoint, controlPoint: CGPoint)

// Paths
func path(path: UIBezierPath)

// Rects
func rect(rect: CGRect)
func rect(origin origin: CGPoint, size: CGSize)
func rect(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
func rect(at center: CGPoint, radius: CGFloat)
func rect(at center: CGPoint, size: CGSize)

// Ovals
func oval(rect: CGRect)
func oval(origin origin: CGPoint, size: CGSize)
func oval(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
func oval(at center: CGPoint, radius: CGFloat)
func oval(at center: CGPoint, size: CGSize)

// Rounded rects
func roundedRect(rect: CGRect, cornerRadius: CGFloat)
func roundedRect(origin origin: CGPoint, size: CGSize, cornerRadius: CGFloat)
func roundedRect(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, cornerRadius: CGFloat)
func roundedRect(at center: CGPoint, radius: CGFloat, cornerRadius: CGFloat)
func roundedRect(at center: CGPoint, size: CGSize, cornerRadius: CGFloat)

// Transforms
func transform(transform: CGAffineTransform)
func translation(tx tx: CGFloat, ty: CGFloat)
func translation(up distance: CGFloat)
func translation(left distance: CGFloat)
func translation(down distance: CGFloat)
func translation(right distance: CGFloat)
func scale(sx sx: CGFloat, sy: CGFloat)
func scale(horizontally ratio: CGFloat)
func scale(vertically ratio: CGFloat)
func rotation(angle: CGFloat)
func rotation(clockwise angle: CGFloat)
func rotation(anticlockwise angle: CGFloat)

// Closure
func close()
func closed()
```

### Wishlist/API ideas

- Better convenience functions for arcs
    - Should be able to arc to a point
    - Should be able to arc by an angle from the current point, given a radius
    
- Location-aware transforms
    - Scale
      - Scale horizontally around x position
      - Scale horizontally around center
      - Scale vertically around y position
      - Scale vertically around center
      - Flip horizontally around x position
      - Flip horizontally around center
      - Flip vertically around y position
      - Flip vertically around center
    - Translate
      - Translate center to point
      - Translate origin to point
    - Rotation
      - Rotate around point
      - Rotate around x and y
      - Rotate around center
      - Half turn around center
      - Clockwise quarter turn around center
      - Anticlockwise quarter turn around center
    - Combination
      - Stretch to fit size, with origin point
      - Stretch to fit size, with center point
      - Stretch to fit rect
      - Stretch to fit rect, with insets
      - Aspect fit and aspect fill rect (look at UIViewContentMode perhaps)
    
