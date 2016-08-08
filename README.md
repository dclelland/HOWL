# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four bandpass filters in series.

### Screenshot

![HOWL screenshot](/Screenshot.gif?raw=true "HOWL screenshot")

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.3).

### 2.1 wishlist

- Note labels
- MIDI input support
    - kAudioUnitType_RemoteMusicEffect
- 3D touch
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit/OpenGL/EZAudio
- Try out slightly bigger fonts for the iPad Pro
