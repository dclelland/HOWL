# Parity

Perhaps the smallest, dumbest library I've ever published... but I kept using this across projects.

Parity is an integer parity microlibrary. It tells you whether an integer is even or odd!

Parity implements a `IntegerParity` protocol on `Int` and `UInt`.

### Examples

✓ Helpers

```swift

2.isEven
// true

3.isOdd
// true

```

✓ Helpful enum for code readability:

```swift

// Before:
if (number % 2 == 0) {
    print("even")
} else {
    print("odd")
}

// After:
switch number.parity {
    case .Even:
        print("even")
    case .Odd:
        print("odd")
}

```

```swift

// Before:
if (numberA % 2 == numberB % 2) {
    print("both numbers have the same parity")
}

// After:
if (numberA.parity == numberB.parity) {
    print("both numbers have the same parity")
}

```
