AudioUnitExtensions
===================

Convenience methods for taking the pain out of the more common AudioUnit C APIs.

I mainly use this to help with Audiobus. You will likely need to look up the types manually in AudioUnitProperties.h.

## Getters and setters:

```swift
let isInterAppAudioConnected: UInt32 = audioUnit.getValue(for: kAudioUnitProperty_IsInterAppConnected)

let interAppAudioComponentDescription: AudioComponentDescription = audioUnit.getValue(for: kAudioOutputUnitProperty_NodeComponentDescription)
```

## Listeners:

```swift
let audioUnitPropertyListener = AudioUnitPropertyListener { (audioUnit, property) in
    print("IAA status changed")
}
        
audioUnit.add(listener: audioUnitPropertyListener, to: kAudioUnitProperty_IsInterAppConnected)
```
