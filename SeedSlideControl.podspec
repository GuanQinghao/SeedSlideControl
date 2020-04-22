#
# Be sure to run `pod lib lint SeedSlideControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SeedSlideControl'
  s.version          = '1.0.1'
  s.summary          = '无限轮播图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
无限轮播图，支持水平滑动和垂直滑动。
                       DESC

  s.homepage         = 'https://github.com/GuanQinghao/SeedSlideControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GuanQinghao' => 'qinghaoguan@163.com' }
  s.source           = { :git => 'https://github.com/GuanQinghao/SeedSlideControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.source_files = 'SeedSlideControl/Classes/**/*'
  s.dependency 'SDWebImage','~> 5.7'
  
  # s.resource_bundles = {
  #   'SeedSlideControl' => ['SeedSlideControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
