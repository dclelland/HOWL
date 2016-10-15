# Bezzy

Bezzy is a collection of simple helpers for building UIBezierPaths.

Swift port of my old [UIBezierPath+DSL](https://github.com/dclelland/UIBezierPath-DSL) Cocoapod.

✓ Movements (with support for positioning relative to `currentPoint`)

```swift
let path = UIBezierPath { path in
    path.add(.move, x: 0.5, y: 0.5)
    path.add(.line, 0.5, .up)
    path.add(.line, 0.5, .right)
    path.add(.line, 0.5, .down)
    path.add(.line, 1.0, .left)
    path.add(.line, 0.5, .down)
    path.add(.line, 0.5, .right)
    path.close()
}
```

✓ Shapes

```swift
let path = UIBezierPath { path in
    path.add(.rect, at: CGRect(x: 0.5, y: 0.5, width: 10.0, height: 20.0))
    path.add(.oval, center: CGPoint(x: 0.5, y: 0.5), radius: 20.0)
    path.add(.roundedRect(cornerRadius: 4.0), center: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 40.0, height: 20.0))
}
```

✓ Transformations

```swift
let path = UIBezierPath { path in
    path.add(.oval, x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    path.scale(0.5, .horizontal)
    path.rotate(45 * .pi / 180, .anticlockwise)
    path.translate(50.0, .right)
}
```

### Full API:

UIBezierPath

```swift
// Constructors
init(_ closure: (UIBezierPath) -> Void)
static func make(_ path: UIBezierPath, _ closure: (UIBezierPath) -> Void) -> UIBezierPath

// Movements
func add(_ movement: Movement, to point: CGPoint)
func add(_ movement: Movement, x: CGFloat, y: CGFloat)
func add(_ movement: Movement, dx: CGFloat, dy: CGFloat)
func add(_ movement: Movement, r: CGFloat, θ: CGFloat)
func add(_ movement: Movement, _ r: CGFloat, _ direction: Direction)

// Shapes
func add(_ shape: Shape, at rect: CGRect)
func add(_ shape: Shape, origin: CGPoint, size: CGSize)
func add(_ shape: Shape, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
func add(_ shape: Shape, center: CGPoint, radius: CGFloat)
func add(_ shape: Shape, center: CGPoint, size: CGSize)

// Transforms
func translate(tx: CGFloat, ty: CGFloat)
func translate(r: CGFloat, θ: CGFloat)
func translate(_ r: CGFloat, _ direction: Direction)
func scale(sx: CGFloat, sy: CGFloat)
func scale(_ ratio: CGFloat, _ axis: Axis)
func rotate(_ angle: CGFloat, _ motion: Motion = .clockwise)
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
    
