# Degrad

Degrad is a microlibrary for working with angles. It provides functions from converting degrees to radians, and rectangular to polar coordinates.

Degrad works by implementing `Degradable` and `Polrectable` protocols on `Float`, `Double`, and `CGFloat`.

### Versions

#### 0.2.0

Added `Polrectable` protocol and `clamp()` function.

### Examples

✓ Terse unit syntax

```swift

180.degrees
// 3.1415926535897931

π.radians
// 180

```

✓ Converter functions

```swift

deg2rad(90)
// 1.5707963267948966

rad2deg(π / 2)
// 90

rec2pol(x: 0, y: 1)
// (r = 1, θ = 1.5707963267948966)

pol2rec(r: 1, θ: 90°)
// (x = 0, y = 1)

```

✓ Fancy unicode pi constant and degree symbol postfix operator (if you're into that kind of thing)

```swift

π
// 3.1415926535897931

45°
// 0.78539816339744828

```
