Pod::Spec.new do |spec|
  spec.name         = "RushSDK"
  spec.version      = "2.10.2"
  spec.summary      = "SDK for analytics in Rush apps"
  spec.description  = "SDK for analytics in Rush apps"
  spec.homepage     = "https://github.com/AgentChe/"
  spec.license      = "MIT"
  spec.author             = { "Andrey Chernyshev" => "akonst17@gmail.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '12.0'
  spec.source       = { :git => "https://github.com/AgentChe/RushSDK.git", :branch => "master", :tag => "#{spec.version}" }
  spec.source_files  = "RushSDK/**/*.{h,m,swift}"
  spec.public_header_files = "RushSDK/**/*.h"
  
  spec.static_framework = true
  
  spec.frameworks = 'UIKit', 'StoreKit'
  spec.dependency 'Alamofire'
  spec.dependency 'RxSwift'
  spec.dependency 'RxCocoa'
  spec.dependency 'SwiftyStoreKit'
  spec.dependency 'FBSDKCoreKit'
  spec.dependency 'Amplitude-iOS'
  spec.dependency 'Branch'
  spec.dependency 'Firebase/Analytics'
  spec.dependency 'Firebase/Messaging'
  spec.dependency 'Firebase/Crashlytics'
  spec.dependency 'AppsFlyerFramework'
end
