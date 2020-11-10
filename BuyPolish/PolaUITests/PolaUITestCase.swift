import FBSnapshotTestCase
import XCTest

class PolaUITestCase: FBSnapshotTestCase {
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

    func snapshotVerifyView(file: StaticString = #file, line: UInt = #line) {
        let fullscreen = app.screenshot().image
        FBSnapshotVerifyView(UIImageView(image: fullscreen), file: file, line: line)
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

    override func record(_ issue: XCTIssue) {
        let imageData = app.screenshot().image.pngData()
        var filename = classForCoder.description()
        if let lineNumber = issue.sourceCodeContext.location?.lineNumber {
            filename.append("_line_\(lineNumber)")
        }
        filename.append(".png")
        if let path = failureImageDirectoryPath?.appendingPathComponent(filename) {
            try? imageData?.write(to: path)
        }
        super.record(issue)
    }

    private var failureImageDirectoryPath: URL? {
        let fileManager = FileManager.default
        guard let pathString = ProcessInfo.processInfo.environment["FAILED_UI_TEST_DIR"] else {
            return nil
        }

        let path = URL(fileURLWithPath: pathString)
        if !fileManager.fileExists(atPath: path.absoluteString) {
            try? fileManager.createDirectory(
                at: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return path
    }
}
