// swift-tools-version:5.9
// Test-only package: builds the Swift bridge with the vendored iOS SDK so its
// unit tests run with `xcodebuild test`. Apps get the pod, not this; it is
// left out of the npm package.
import PackageDescription

let package = Package(
    name: "FloadAttributionBridge",
    platforms: [.iOS(.v15)],
    targets: [
        .target(
            name: "FloadAttributionBridge",
            path: ".",
            exclude: ["FloadAttributionModule.h", "FloadAttributionModule.mm", "Tests", "Vendor/FloadAttribution/VENDORED.txt"],
            sources: ["FloadAttributionBridge.swift", "Vendor/FloadAttribution"]
        ),
        .testTarget(
            name: "FloadAttributionBridgeTests",
            dependencies: ["FloadAttributionBridge"],
            path: "Tests/FloadAttributionBridgeTests"
        ),
    ]
)
