source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'AudioKit', '~> 2.3'
pod 'Bezzy', '~> 0.1'
pod 'MultitouchGestureRecognizer', '~> 0.1'
pod 'ProtonomeRoundedViews', '~> 0.1'
pod 'ProtonomeAudioKitControls', path: '../ProtonomeAudioKitControls'
pod 'SnapKit', '~> 0.17'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
