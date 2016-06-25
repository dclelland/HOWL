# Persistable

Simple type safe persistable values to use as settings within your app.

Currently supports `Bool`, `Int`, `Float`, and `Double`.

✓ Easy interface

```swift

// Configuration
struct Settings {

    static var darkMode = Persistent(value: false, key: "darkMode")
    static var openCount = Persist(value: 0, key: "openCount")
    static var volume = Persist(value: 1.0, key: "volume")

}

// Setting
Settings.darkMode.value = true
Settings.openCount.value = Settings.openCount.value + 1
Settings.volume.resetValue()

// Getting
print(Settings.darkMode.value) // true
print(Settings.openCount.value) // 1

```

✓ Easily extend other types

```swift

enum AudioState: Int {
    case On
    case Off
    case Disabled
}

extension AudioState: PersistableType {
    
    init(persistentObject: AnyObject) {
        self = AudioState(rawValue: (persistentObject as! NSNumber).integerValue)!
    }
    
    var persistentObject: AnyObject {
        return NSNumber(integer: self.rawValue)
    }

}

var audioState = Persistent<AudioState>(value: .On, key: "audioState")

```

### Todo:

- Strings
- Arrays (might have to wait for extensible generics)
- Dictionaries (might have to wait for extensible generics)
