import Foundation
import os

/// The Objective-C face of the vendored Fload iOS SDK (`ios/Vendor/FloadAttribution`),
/// which the React Native module calls. It maps strings to the SDK's options and
/// changes nothing else. It uses only the SDK's public API.
@objc(FloadAttributionBridge)
public final class FloadAttributionBridge: NSObject {
    @objc(configureWithKey:endpoint:logLevel:wrapperName:wrapperVersion:)
    public static func configure(key: String, endpoint: String?, logLevel: String, wrapperName: String, wrapperVersion: String) {
        guard let options = options(endpoint: endpoint, logLevel: logLevel, wrapperName: wrapperName, wrapperVersion: wrapperVersion) else {
            Logger(subsystem: "com.fload.attribution", category: "react-native")
                .error("FloadAttribution.configure: the endpoint is not a URL. Attribution is off.")
            return
        }
        Fload.configure(key: key, options: options)
    }

    /// The SDK's options from the JS strings; nil when the endpoint is not a URL.
    /// The wrapper (this package's name and version, from JS) goes on every request as `sdk.wrapper`.
    static func options(endpoint: String?, logLevel: String, wrapperName: String, wrapperVersion: String) -> FloadOptions? {
        var options = FloadOptions(logLevel: level(logLevel), wrapper: FloadWrapper(name: wrapperName, version: wrapperVersion))
        if let endpoint, !endpoint.isEmpty {
            guard let url = URL(string: endpoint) else { return nil }
            options.endpoint = url
        }
        return options
    }

    @objc(setUserId:)
    public static func setUserId(_ userId: String) {
        Fload.setUserId(userId)
    }

    @objc public static var installReference: String? {
        Fload.installReference
    }

    static func level(_ name: String) -> FloadLogLevel {
        switch name {
        case "none": return .none
        case "error": return .error
        case "info": return .info
        case "debug": return .debug
        default: return .warning
        }
    }
}
