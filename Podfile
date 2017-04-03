source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', git: 'https://github.com/dclelland/AudioKit/', branch: 'protonome'
pod 'AudioUnitExtensions', '~> 0.1'
pod 'Bezzy', '~> 1.0'
pod 'MultitouchGestureRecognizer', '~> 1.1'
pod 'Parity', '~> 1.0'
pod 'Persistable', '~> 1.0'
pod 'ProtonomeAudioKitControls', '~> 1.2'
pod 'ProtonomeRoundedViews', '~> 1.0'
pod 'SnapKit', '~> 3.0'

target 'HOWL'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist')
end
