source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', git: 'https://github.com/dclelland/AudioKit/', branch: 'howl'
#pod 'Bezzy', '~> 0.1'
pod 'Bezzy', path: '../../Libraries/Bezzy/'
#pod 'MultitouchGestureRecognizer', '~> 0.1'
pod 'MultitouchGestureRecognizer', path: '../../Libraries/MultitouchGestureRecognizer'
#pod 'Parity', '~> 0.1'
pod 'Parity', path: '../../Libraries/Parity'
#pod 'Persistable', '~> 0.1'
pod 'Persistable', path: '../../Libraries/Persistable'
#pod 'ProtonomeAudioKitControls', '~> 0.3'
pod 'ProtonomeAudioKitControls', path: '../../Libraries/ProtonomeAudioKitControls'
#pod 'ProtonomeRoundedViews', '~> 0.1'
pod 'ProtonomeRoundedViews', path: '../../Libraries/ProtonomeRoundedViews'
pod 'SnapKit', '~> 3.0'

target 'HOWL'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
