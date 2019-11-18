#
# Be sure to run `pod lib lint NetworkClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'NetworkClient'
s.version          = '1.0.1'
s.summary          = 'A short description of NetworkClient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://git.finch.fm/Finch-iOS/NetworkClient'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'MaximSmirnov' => 'atimca@gmail.com' }
s.source           = { :git => 'git@git.finch.fm:Finch-iOS/NetworkClient.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'
s.tvos.deployment_target = '9.0'

s.source_files = 'Source/**/*'

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

# s.resource_bundles = {
#   'NetworkClient' => ['NetworkClient/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end

