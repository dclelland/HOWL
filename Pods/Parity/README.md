# Parity

Parity is an integer parity microlibrary. It tells you whether an integer is even or odd!

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
    case .even:
        print("even")
    case .odd:
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