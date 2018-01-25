#
# Be sure to run `pod lib lint Updraft.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Updraft'
  s.version          = '0.1.0'
  s.summary          = 'Updraft is a Swift tool for running executable specifications written in a plain language.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Updraft is a Swift tool for running executable specifications written in a plain language. It is a Swift implementation of Cucumber, using the Gherkin language. Cucumber is a tool for running automated tests written in plain language. Because they're written in plain language, they can be read by anyone on your team. Because they can be read by anyone, you can use them to help improve communication, collaboration and trust on your team.
                       DESC

  s.homepage         = 'https://github.com/davidweiss/updraft'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'davidweiss' => 'davidweiss@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/davidweiss/updraft.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/davidweiss'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'

  s.source_files = 'Updraft/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Updraft' => ['Updraft/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
