# Lerp

Lerp is a linear interpolation microlibrary.

I got sick of copying and pasting these functions into every project, so I made a Cocoapod.

Lerp implements a `Lerpable` protocol on `Float`, `Double`, and `CGFloat` - mostly cribbed from [this Stack Overflow post](http://stackoverflow.com/questions/29930729/swift-protocol-similar-to-equatable).

### Versions

#### 0.2.0

Added external parameter names for aesthetics

#### 0.1.2

Added `Clampable` protocol and `clamp()` function.

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