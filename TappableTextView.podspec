#
# Be sure to run `pod lib lint TappableTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TappableTextView'
  s.version          = '2.0.0'
  s.summary          = 'A UITextView that handles taps on text with the view.'

  s.swift_version = '5.0'
  s.ios.deployment_target  = '13.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TappableTextView makes it laughably easy to turn any word into a button. With beautiful animations and easy to understand code, you can turn any simple body of text into a world of possibilites.
                       DESC

  s.homepage         = 'https://github.com/SlickJohnson/TappableTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SlickJohnson' => 'liwa.johnson@gmail.com' }
  s.source           = { :git => 'https://github.com/SlickJohnson/TappableTextView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = ['TappableTextView/Classes/*']
  
  s.resource_bundles = {
    'TappableTextView' => ['TappableTextView/Assets/**/*'],
  }

  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
