source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '16.0'

use_frameworks!

pod 'AudioKit', git: 'https://github.com/dclelland/AudioKit/', branch: 'protonome'
pod 'Bezzy', '~> 1.4'
pod 'MultitouchGestureRecognizer', '~> 2.2'
pod 'Parity', '~> 2.2'
pod 'Persistable', '~> 1.3'
pod 'ProtonomeAudioKitControls', '~> 1.5'
pod 'ProtonomeRoundedViews', '~> 1.2'
pod 'SnapKit', '~> 5.0'

target 'HOWL'

post_install do |installer|
    
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
            end
        end
    end
    
    require 'fileutils'
    FileUtils.cp('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist')
    
end
