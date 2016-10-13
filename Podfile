source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', git: 'https://github.com/dclelland/AudioKit/', branch: 'howl'
#pod 'Bezzy', '~> 0.1'
pod 'Bezzy', path: '../../Libraries/Bezzy/'
pod 'MultitouchGestureRecognizer', '~> 1.0'
pod 'Parity', '~> 1.0'
pod 'Persistable', '~> 1.0'
#pod 'ProtonomeAudioKitControls', '~> 1.0'
pod 'ProtonomeAudioKitControls', path: '../../Libraries/ProtonomeAudioKitControls'
pod 'ProtonomeRoundedViews', '~> 1.0'
pod 'SnapKit', '~> 3.0'

target 'HOWL'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
