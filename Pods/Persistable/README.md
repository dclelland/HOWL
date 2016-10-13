# Persistable

Simple type safe persistable values to use as settings within your app.

Supports the type `Any`, which you should read as, "anything which is okay with being sent to `UserDefaults.standard.set(forKey:)`".

```swift

// Configuration
struct Settings {

    static var darkMode = Persistent(value: false, key: "darkMode")
    
    static var openCount = Persistent(value: 0, key: "openCount")
    
    static var volume = Persistent(value: 1.0, key: "volume") {
        didSet {
            print("Volume changed to \(volume.value)")
        }
    }

}

// Setting
Settings.darkMode.value = true
Settings.openCount.value = Settings.openCount.value + 1
Settings.volume.resetValue()

// Getting
print(Settings.darkMode.value) // true
print(Settings.openCount.value) // 1

```
