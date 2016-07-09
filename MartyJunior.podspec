#
# Be sure to run `pod lib lint MartyJunior.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MartyJunior"
  s.version          = "0.3.0"
  s.summary          = "You can change tab contents with swipe gesture on middle of UITableView!!"

  s.homepage         = "https://github.com/szk-atmosphere/MartyJunior"

  s.license          = 'MIT'
  s.author           = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.source           = { :git => "https://github.com/szk-atmosphere/MartyJunior.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SzkAtmosphere'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'MartyJunior/*.{swift}'
  #s.resource_bundles = {
  #  'MartyJunior' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
#  s.dependency 'MisterFusion'
end
