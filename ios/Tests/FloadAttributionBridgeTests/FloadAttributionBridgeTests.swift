@testable import FloadAttributionBridge
import XCTest

final class FloadAttributionBridgeTests: XCTestCase {
    func testEveryJsLogLevelMapsToTheSdks() {
        let expected: [String: FloadLogLevel] = [
            "none": .none, "error": .error, "warning": .warning, "info": .info, "debug": .debug,
        ]
        for (name, level) in expected {
            XCTAssertEqual(FloadAttributionBridge.level(name), level, name)
        }
    }

    func testAnUnknownLogLevelFallsBackToWarning() {
        XCTAssertEqual(FloadAttributionBridge.level("verbose"), .warning)
    }

    func testOptionsNameTheWrapperAndTheVersionJsSends() {
        let options = FloadAttributionBridge.options(
            endpoint: nil, logLevel: "debug", wrapperName: "react-native", wrapperVersion: "1.1.0"
        )
        XCTAssertEqual(options?.wrapper, FloadWrapper(name: "react-native", version: "1.1.0"))
        XCTAssertEqual(options?.endpoint, URL(string: "https://ingest.fload.com"))
        XCTAssertEqual(options?.logLevel, .debug)
    }

    func testOptionsWithAnEndpointNameTheWrapperToo() {
        let options = FloadAttributionBridge.options(
            endpoint: "http://localhost:3999", logLevel: "warning", wrapperName: "react-native", wrapperVersion: "1.1.0"
        )
        XCTAssertEqual(options?.endpoint, URL(string: "http://localhost:3999"))
        XCTAssertEqual(options?.wrapper, FloadWrapper(name: "react-native", version: "1.1.0"))
    }

    func testAnEmptyEndpointMeansFloadsAndAnInvalidOneIsRefused() {
        let empty = FloadAttributionBridge.options(
            endpoint: "", logLevel: "warning", wrapperName: "react-native", wrapperVersion: "1.1.0"
        )
        XCTAssertEqual(empty?.endpoint, URL(string: "https://ingest.fload.com"))
        XCTAssertNil(FloadAttributionBridge.options(
            endpoint: "not a url", logLevel: "warning", wrapperName: "react-native", wrapperVersion: "1.1.0"
        ))
    }

    func testTheObjectiveCNamesTheModuleCallsExist() {
        let bridge: AnyClass = FloadAttributionBridge.self
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("configureWithKey:endpoint:logLevel:wrapperName:wrapperVersion:")))
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("setUserId:")))
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("installReference")))
        XCTAssertEqual(NSStringFromClass(bridge), "FloadAttributionBridge")
    }

    func testInstallReferenceIsNilBeforeConfigure() {
        XCTAssertNil(FloadAttributionBridge.installReference)
    }
}
