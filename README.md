# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four parallel bandpass filters.

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.2).

### 2.0 todo

- Show note names while holding down dial?

### 2.1 wishlist

- MIDI input support
    - kAudioUnitType_RemoteMusicEffect
- 3D touch
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit/OpenGL/EZAudio
- Try out slightly bigger fonts for the iPad Pro
