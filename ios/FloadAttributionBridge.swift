import Foundation
import os

/// The Objective-C face of the vendored Fload iOS SDK (`ios/Vendor/FloadAttribution`),
/// which the React Native module calls. It maps strings to the SDK's options and
/// changes nothing else. It uses only the SDK's public API.
@objc(FloadAttributionBridge)
public final class FloadAttributionBridge: NSObject {
    @objc(configureWithKey:endpoint:logLevel:)
    public static func configure(key: String, endpoint: String?, logLevel: String) {
        var options = FloadOptions(logLevel: level(logLevel))
        if let endpoint, !endpoint.isEmpty {
            guard let url = URL(string: endpoint) else {
                Logger(subsystem: "com.fload.attribution", category: "react-native")
                    .error("FloadAttribution.configure: the endpoint is not a URL. Attribution is off.")
                return
            }
            options.endpoint = url
        }
        Fload.configure(key: key, options: options)
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
