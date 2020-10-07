Pod::Spec.new do |spec|
  spec.name         = "RushSDK"
  spec.version      = "1.1.3"
  spec.summary      = "SDK for analytics in Rush apps"
  spec.description  = "SDK for analytics in Rush apps"
  spec.homepage     = "https://github.com/AgentChe/"
  spec.license      = "MIT"
  spec.author             = { "Andrey Chernyshev" => "akonst17@gmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/AgentChe/RushSDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "RushSDK/**/*.{h,m,swift}"
  spec.public_header_files = "RushSDK/**/*.h"
  
  spec.frameworks = 'UIKit'
  spec.dependency 'Alamofire'
  spec.dependency 'RxSwift'
  spec.dependency 'RxCocoa'
end
