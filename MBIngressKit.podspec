Pod::Spec.new do |s|
  s.name          = "MBIngressKit"
  s.version       = "2.0.0"
  s.summary       = "MBIngressKit is a public Pod of MBition GmbH" 
  s.description   = "The main part of this module is IngressKit, it is the facade to communicate with all provided services. It provides the functionality to log the user in and out with its loginService and to handle the user data with its userService. When the user logs in, the user data gets cached and removed when he logs out."
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-IngressKit-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '10.0'
  s.swift_version = ['5.0', '5.1', '5.2']

  s.source_files = 'MBIngressKit/MBIngressKit/**/*.{swift,xib}'

  # internal dependencies
  s.dependency 'MBCommonKit/Logger', '~> 2.0'
  s.dependency 'MBCommonKit/Protocols', '~> 2.0'
  s.dependency 'MBNetworkKit/Basic', '~> 2.0'
  s.dependency 'MBNetworkKit/Image', '~> 2.0'
  s.dependency 'MBRealmKit/Layer', '~> 2.0'

  # public dependencies
  s.dependency 'JWTDecode', '~> 2.1'

end
