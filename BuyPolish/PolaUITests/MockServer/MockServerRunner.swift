import XCTest

@objc(MockServerRunner)
final class MockServerRunner: NSObject, XCTestObservation {
    let mockServer = MockServer.shared

    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }

    func testBundleWillStart(_: Bundle) {
        do {
            NSLog("MockServer: Starting...")
            try mockServer.start()
        } catch {
            NSLog("MockServer: Failed start server with error \(error)")
        }
    }

    func testBundleDidFinish(_: Bundle) {
        mockServer.stop()
        NSLog("MockServer: Stopped")
    }
}
