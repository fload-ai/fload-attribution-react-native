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

    func testTheObjectiveCNamesTheModuleCallsExist() {
        let bridge: AnyClass = FloadAttributionBridge.self
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("configureWithKey:endpoint:logLevel:")))
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("setUserId:")))
        XCTAssertTrue(bridge.responds(to: NSSelectorFromString("installReference")))
        XCTAssertEqual(NSStringFromClass(bridge), "FloadAttributionBridge")
    }

    func testInstallReferenceIsNilBeforeConfigure() {
        XCTAssertNil(FloadAttributionBridge.installReference)
    }
}
