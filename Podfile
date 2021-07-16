platform :ios, '12.3'
#platform :osx, '11.0'

target 'FlickrFinder' do
  use_frameworks!
  inhibit_all_warnings!
  
  # Code style
  pod 'SwiftLint'
  
  # More beautiful layout for collection view
  pod 'CollectionViewWaterfallLayout'
  
  # Codeless keyboard appearance tool
  pod 'IQKeyboardManagerSwift'
  
  # Handy reusable cells implementation on generics
  pod 'Reusable'

  target 'FlickrFinderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FlickrFinderUITests' do
    # Pods for testing
  end
  
  # Fixing deployment target warning
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if Gem::Version.new('12.3') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.3'
        end
      end
    end
  end

end
