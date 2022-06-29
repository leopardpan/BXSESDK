#
# Be sure to run `pod lib lint BXSESDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BXSESDK'
  s.version          = '0.1.2'
  s.summary          = 'SESDK 测试项目.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    BXSESDK (0.1.2)
             DESC

  s.homepage         = 'https://github.com/leopardpan/BXSESDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leopardpan' => 'leopardpan@icloud.com' }
  s.source           = { :git => 'https://github.com/leopardpan/BXSESDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

#  s.source_files = 'BXSESDK/Classes/**/*'
  s.ios.vendored_frameworks = 'BXSESDK/Classes/SolarEngineSDK.framework'

  # s.resource_bundles = {
  #   'BXSESDK' => ['BXSESDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation', 'Security', 'CoreTelephony','AdSupport','SystemConfiguration'
   s.libraries  = 'sqlite3', 'z'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
