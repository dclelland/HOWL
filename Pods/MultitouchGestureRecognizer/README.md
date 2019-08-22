# MultitouchGestureRecognizer

MultitouchGestureRecognizer is a UIGestureRecognizer subclass providing a richer API for working with multiple touches.

Demo project available in the `Multitouch` directory.

#### Installation:

```ruby
pod 'MultitouchGestureRecognizer', '~> 2.0'
```

#### Usage:

```swift
let gestureRecognizer = MultitouchGestureRecognizer()
gestureRecognizer.delegate = self
view.addGestureRecognizer(gestureRecognizer)
```

### Features:

✓ Maximum touch count setting and stack/queue option:

```swift
// Only register the five touches received first:
gestureRecognizer.mode = .stack
gestureRecognizer.count = 5

// Only register the one touch received last:
gestureRecognizer.mode = .queue
gestureRecognizer.count = 1
```

✓ Sustain setting for retaining touches at the end of a gesture (ideal for, say, implementing a piano keyboard with a sustain function)

```swift
gestureRecognizer.sustain = true
```

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

✓ Keeps track of the gesture's state and touches:

```swift
if (gestureRecognizer.multitouchState == .live) {
    print("Gesture recognizer is currently receiving touches:", gestureRecognizer.touches)
}
```

✓ Centroid helper

```swift
print(multitouchGestureRecognizer.centroid) // Prints the average of all touches
```

### Todo:

- Make GIF preview
- Publish to Carthage
- Publish to Cocoa controls
