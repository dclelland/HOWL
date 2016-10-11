# Lerp

Lerp is a linear interpolation microlibrary.

I got sick of copying and pasting these functions into every project, so I made a Cocoapod.

Lerp implements a `Lerpable` protocol on `Float`, `Double`, `CGFloat`, and `CGPoint` - mostly cribbed from [this Stack Overflow post](http://stackoverflow.com/questions/29930729/swift-protocol-similar-to-equatable).

### Examples

✓ Linear interpolation

```swift

lerp(0.5, min: 30, max: 40)
// 35

```

✓ Inverse linear interpolation

```swift

ilerp(35, min: 30, max: 40)
// 0.5

```

✓ Clamping

```swift

clamp(35, min: 30, max: 40)
// 35

clamp(25, min: 30, max: 40)
// 20

clamp(45, min: 30, max: 40)
// 40

```

### CGPoint helpers:

```swift

CGPoint(x: 0.5, y: 0.5).lerp(min: CGPoint(x: 0.0, y: 0.0), max: CGPoint(x: 20.0, y: 40.0))
// CGPoint(x: 10.0, y: 20.0)

CGPoint(x: 0.5, y: 0.5).lerp(rect: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
// CGPoint(x: 10.0, y: 20.0)

CGPoint(x: 10.0, y: 20.0).ilerp(min: CGPoint(x: 0.0, y: 0.0), max: CGPoint(x: 20.0, y: 40.0))
// CGPoint(x: 0.5, y: 0.5)

CGPoint(x: 10.0, y: 20.0).ilerp(rect: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
// CGPoint(x: 0.5, y: 0.5)

CGPoint(x: -10.0, y: 50.0).clamp(min: CGPoint(x: 0.0, y: 0.0), max: CGPoint(x: 20.0, y: 40.0))
// CGPoint(x: 0.0, y: 40.0)

CGPoint(x: -10.0, y: 50.0).clamp(rect: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
// CGPoint(x: 0.0, y: 40.0)

```

### CGRect helpers:

```swift

CGRect(x: 0.0, y: 0.0, width: 0.5, height: 0.5).lerp(rect: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
// CGRect(x: 0.0, y: 0.0, width: 10.0, height: 20.0)

CGRect(x: 0.0, y: 0.0, width: 10.0, height: 20.0).ilerp(rect: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
// CGRect(x: 0.0, y: 0.0, width: 0.5, height: 0.5)

```
