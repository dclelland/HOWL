source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', '~> 2.3'
pod 'Bezzy', '~> 0.1'
pod 'MultitouchGestureRecognizer', '~> 0.1'
pod 'Parity', '~> 0.1'
pod 'ProtonomeAudioKitControls', '~> 0.3'
pod 'ProtonomeRoundedViews', '~> 0.1'
pod 'SnapKit', '~> 0.17'

target 'HOWL'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
