# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four parallel bandpass filters.

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.2).

### 2.0 Todo

- Audiobus todo
    - Fork AudioKit
        - The AVAudioSessionCategoryOptionMixWithOthers thing
            - See https://github.com/audiokit/AudioKit/blob/84981bf694088405020974caf1b8ef986e859790/AudioKit/Common/Internals/AKSettings.swift
        - The AudioUnit thing

- Persistent notes/vocoder state when opening and closing the app
- Bug in reloadNotes when you change waveform (seems to have vanished?)
- Try out slightly bigger fonts for iPad/iPad Pro support
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit
    - https://github.com/syedhali/EZAudio#EZAudioPlot
    - After running the profiler, turns out both of these are the biggest performance sink
    - https://spin.atomicobject.com/2014/05/28/ios-interpolating-points/
- Fix that random crash
- Show note names while holding down dial?

### Wishlist

- MIDI input support
    - kAudioUnitType_RemoteMusicEffect
- 3D touch
