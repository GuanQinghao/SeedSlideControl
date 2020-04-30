#
# Be sure to run `pod lib lint SeedSlideControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  # 名称
  s.name             = 'SeedSlideControl'
  # 版本
  s.version          = '1.0.4'
  # 概述
  s.summary          = '无限轮播控件'
  # 首页
  s.homepage         = 'https://github.com/GuanQinghao/SeedSlideControl'
  # 许可证书
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者
  s.author           = { 'GuanQinghao' => 'qinghaoguan@163.com' }
  # 源文件地址
  s.source           = { :git => 'https://github.com/GuanQinghao/SeedSlideControl.git', :tag => s.version.to_s }
  # iOS部署版本
  s.ios.deployment_target = '10.0'
  # 源文件路径
  s.source_files = 'SeedSlideControl/Classes/**/*'
  # 依赖
  s.dependency 'SDWebImage','~> 5.7'
end
