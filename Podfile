source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', '~> 3.4'
pod 'Bezzy', '~> 1.0'
pod 'MultitouchGestureRecognizer', '~> 1.0'
pod 'Parity', '~> 1.0'
pod 'Persistable', '~> 1.0'
pod 'ProtonomeAudioKitControls', path: '../../Libraries/ProtonomeAudioKitControls'
pod 'ProtonomeRoundedViews', '~> 1.0'
pod 'SnapKit', '~> 3.0'

target 'HOWL'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
