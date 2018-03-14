#
# Be sure to run `pod lib lint CreatuNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CreatuNetwork'
  s.version          = '0.1.0'
  s.summary          = 'This is Network request library. depends upon RXSwift, RxXoxoa, Moya/RxSwift, ReachabilitySwift '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mohansinghthagunna/CreatuNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mohansinghthagunna' => 'mohansingh_thagunna@outlook.com' }
  s.source           = { :git => 'https://github.com/mohansinghthagunna/CreatuNetwork.git', :tag => s.version.to_s }
 s.social_media_url = 'https://twitter.com/sngmon'

  s.ios.deployment_target = '10.0'
   s.swift_version = '4.0'
  s.source_files = 'CreatuNetwork/**/*'
  
  # s.resource_bundles = {
  #   'CreatuNetwork' => ['CreatuNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency "RxSwift", "~> 4.1.2"
  s.dependency "RxCocoa", "~> 4.1.2"
  s.dependency "Moya/RxSwift", "~> 11.0.1"
  s.dependency "ReachabilitySwift", "~> 4.1.0"
end
