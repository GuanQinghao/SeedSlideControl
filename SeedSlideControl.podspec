#
# Be sure to run `pod lib lint SeedSlideControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name = 'SeedSlideControl'
    s.version = '1.1.0'
    s.summary = '无限轮播控件'
    s.homepage = 'https://github.com/GuanQinghao/SeedSlideControl'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.author = { 'GuanQinghao' => 'qinghaoguan@163.com' }
    s.source = { :git => 'https://github.com/GuanQinghao/SeedSlideControl.git', :tag => s.version.to_s }
    s.ios.deployment_target = '11.0'
    s.source_files = 'SeedSlideControl/Classes/**/*'
    s.dependency 'SDWebImage'
end
