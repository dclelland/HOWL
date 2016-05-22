# HOWL

HOWL is a simple formant synthesizer for iOS, written in Swift and built using the [AudioKit](https://github.com/audiokit/AudioKit) framework.

It's extremely basic - just a sawtooth wave VCO run through four parallel bandpass filters.

### Links

- [Project page](http://protonome.com/apps/howl/)
- [App store](https://itunes.apple.com/us/app/howl-a-formant-synthesizer/id1067562312)

### Building

Just open `HOWL.xcworkspace` in Xcode and hit build (as of the time of writing the latest version is Xcode 7.2).

### 2.0 Todo

- Formant LFO system
    - Try reloading the instrument
    - Try wave tables
    - Try having 4 LFOs (lol)
        - An if statement might be quite efficient perhaps, could do the same in the synth as in the vocoder
- Realign formants - need affine transform
- Bug in reloadNotes when you change waveform
- Bug in number formatter - can print "-0"
- Fix up PhonemeboardView IBDesignable issues
- iPad Pro splash screen
    - Might be able to use IBDesignable views...?
- Rebuild the phonemeboard/keyboard using Metal/SpriteKit
    - https://spin.atomicobject.com/2014/05/28/ios-interpolating-points/
- Audiobus
    - Passthrough

### Wishlist

- MIDI input support
- 3D touch
