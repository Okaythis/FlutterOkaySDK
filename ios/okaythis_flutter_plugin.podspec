#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'okaythis_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Okaythis.'
  s.description      = <<-DESC
A Flutter plugin for Okaythis SDK.
                       DESC
  s.homepage         = 'http://okaythis.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Okaythis' => 'hello@okaythis.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
#  s.preserve_paths = 'PSA.framework'
#  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework PSA' }
#  s.vendored_frameworks = 'PSA.framework'
#
#  s.preserve_paths = 'PSACommon.framework'
#  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework PSACommon' }
#  s.vendored_frameworks = 'PSACommon.framework'

  s.dependency 'PSASDK', '~> 1.0.7'
  s.ios.deployment_target = '10.0'
  
end

