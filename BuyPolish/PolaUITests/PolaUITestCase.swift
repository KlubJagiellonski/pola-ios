import SnapshotTesting
import XCTest

class PolaUITestCase: XCTestCase {
    var startingPageObject: ScanBarcodePage!
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchEnvironment = ["POLA_URL": "http://localhost:8888"]
        app.launchArguments += ["--disableAnimations"]
        app.launch()

        startingPageObject = ScanBarcodePage(app: app)
    }

    override func tearDown() {
        startingPageObject = nil
        app = nil
        MockServer.shared.clearLogs()
        super.tearDown()
    }

    func snapshotVerifyView(file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        startingPageObject.waitForPasteboardInfoDissappear().done()
        let fullscreen = app.screenshot().image
        assertSnapshot(matching: fullscreen, as: .image, file: file, testName: testName, line: line)
    }

    func expectRequest(path: String, file: StaticString = #file, line: UInt = #line) {
        let predicate = NSPredicate { (object, _) -> Bool in
            let mockServer = object as! MockServer
            return mockServer.loggedRequest.contains(where: { $0.path == path })
        }
        let requestExpectation = expectation(for: predicate, evaluatedWith: MockServer.shared, handler: nil)
        let result = XCTWaiter().wait(for: [requestExpectation], timeout: 10.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "Expected request \(path) not appear", file: file, line: line)
    }

    func skipTest(issueNumber: UInt, file: StaticString = #filePath, line: UInt = #line) -> XCTSkip {
        return XCTSkip("Test to fix more info at https://github.com/KlubJagiellonski/pola-ios/issues/\(issueNumber)",
                       file: file,
                       line: line)
    }
}
