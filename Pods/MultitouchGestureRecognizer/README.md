# MultitouchGestureRecognizer

MultitouchGestureRecognizer is a UIGestureRecognizer subclass providing a richer API for working with multiple touches.

#### Installation:

```ruby
pod 'MultitouchGestureRecognizer', '~> 1.1'
```

#### Usage:

```swift
let gestureRecognizer = MultitouchGestureRecognizer()
gestureRecognizer.delegate = self
view.addGestureRecognizer(gestureRecognizer)
```

### Features:

✓ Delegate protocol methods for individual touches:

```swift
func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
    print("Touch started")
}

func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
    print("Touch updated")
}

func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
    print("Touch cancelled")
}

func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
    print("Touch finished")
}
```

✓ Sustain setting for retaining touches at the end of a gesture (ideal for, say, implementing a piano keyboard with a sustain function)

```swift
gestureRecognizer.sustain = true
```

✓ Keeps track of the gesture's state and touches:

```swift
if (gestureRecognizer.multitouchState == .live) {
    print("Gesture recognizer is currently receiving touches:", gestureRecognizer.touches)
}
```

✓ Centroid helper

```swift
print("multitouchGestureRecognizer.centroid") // Prints the average of all touches
```

### Todo:

- Make GIF preview
- Publish to Carthage
- Publish to Cocoa controls
