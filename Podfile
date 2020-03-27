platform :ios,'10.0'
use_frameworks!
inhibit_all_warnings!
workspace 'MBIngressKit'


def pods
  # code analyser
  pod 'SwiftLint', '~> 0.30'

  # dependencies
  pod 'JWTDecode', '~> 2.1'

  # module
  pod 'MBCommonKit', '~> 2.0'
  pod 'MBNetworkKit', '~> 2.0'
  pod 'MBRealmKit', '~> 2.0'
end


target 'MBIngressKit' do
  project 'MBIngressKit/MBIngressKit'

  pods

  target 'MBIngressKitTests' do 
  end
end

target 'Example' do
  project 'Example/Example'

  pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
