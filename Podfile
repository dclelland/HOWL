source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

pod 'Audiobus', '~> 2.3'
pod 'AudioKit', git: 'https://github.com/dclelland/AudioKit/', branch: 'protonome'
pod 'AudioUnitExtensions', '~> 0.1'
pod 'Bezzy', '~> 1.3'
pod 'MultitouchGestureRecognizer', '~> 2.1'
pod 'Parity', '~> 2.1'
pod 'Persistable', '~> 1.2'
pod 'ProtonomeAudioKitControls', '~> 1.4'
pod 'ProtonomeRoundedViews', '~> 1.1'
pod 'SnapKit', '~> 4.2'

target 'HOWL'

post_install do |installer|
    
    # Set custom build configurations
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            
            # Fix IBDesignables
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            
            # Enable AudioPlot's AudioKit integration
            config.build_settings['PROTONOME_AUDIOKIT_ENABLED'] = true
        end
    end
    
    # Write the acknowledgements
    require 'fileutils'
    FileUtils.cp('Pods/Target Support Files/Pods-HOWL/Pods-HOWL-Acknowledgements.plist', 'HOWL/Resources/Settings.bundle/Acknowledgements.plist')
    
end
