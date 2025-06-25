#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_minizip_ng.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_minizip_ng'
  s.version          = '0.0.1'
  s.summary          = 'A plug-in that can access minizip-ng API via FFI .'
  s.description      = <<-DESC
A plug-in that can access minizip-ng API via FFI .
                       DESC
  s.homepage         = 'https://github.com/catoocraft/flutter_minizip_ng'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'catoocraft' => 'catoocraft@gmail.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m,c,cc,cpp,swift}', '../src/minizip-ng/**/*.{h,c}'

  # If your plugin requires a privacy manifest, for example if it collects user
  # data, update the PrivacyInfo.xcprivacy file to describe your plugin's
  # privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_minizip_ng_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
