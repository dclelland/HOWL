# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four parallel banks of five bandpass filters.

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.2).

### 2.0 Todo

- Formant LFO system
    - Initialise vocoder(s) with cardinal formants, and interpolate
    - Could perhaps infer those values with existing data
    - Use multiple touches, or just simple rotational LFO
    - Could probably remove the Harmony section
- Fix the bitcrush system
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit
- iPad Pro splash screen
- Cram everything into the iPhone version somehow
- Audiobus
    - Passthrough
- Logarithmic scale should support negative numbers

### Wishlist

- MIDI input support
- 3D touch
