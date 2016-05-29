# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four parallel bandpass filters.

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.2).

### 2.0 Todo

- Audiobus
    - Passthrough
    - Background audio:
        - Should only turn off if both HOLD buttons are off
        - Might need settings page addition
        - Will need to shut down audio correctly as per the applicationDidEnterBackground implementation in https://developer.audiob.us/doc/_thirty-_minute-_integration.html
    - What is Inter-app audio and how does it relate?
- Bug in reloadNotes when you change waveform (seems to have vanished?)
- Try out slightly bigger fonts for iPad/iPad Pro support
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit
    - After running the profiler, turns out both of these are the biggest performance sink
    - https://spin.atomicobject.com/2014/05/28/ios-interpolating-points/
- Fix that random crash

### Wishlist

- MIDI input support
- 3D touch
