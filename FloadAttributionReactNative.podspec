require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "FloadAttributionReactNative"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  # The Fload iOS SDK needs iOS 15.
  s.platforms    = { :ios => "15.1" }
  s.source       = { :git => "https://github.com/fload-ai/fload-attribution-react-native.git", :tag => s.version.to_s }
  s.swift_version = "5.9"

  # The module, its Swift bridge, and the Fload iOS SDK vendored byte for
  # byte from github.com/fload-ai/fload-attribution-ios (ios/Vendor/VENDORED.txt).
  s.source_files = "ios/*.{h,mm,swift}", "ios/Vendor/FloadAttribution/*.swift"
  # ios/Package.swift and ios/Tests are only for the bridge's unit tests.
  s.exclude_files = "ios/Package.swift"
  s.private_header_files = "ios/*.h"
  s.resource_bundles = {
    "FloadAttributionPrivacy" => ["ios/Vendor/FloadAttribution/Resources/PrivacyInfo.xcprivacy"]
  }
  s.weak_frameworks = "AdServices"
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }

  install_modules_dependencies(s)
end
