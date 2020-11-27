import SnapshotTesting
import XCTest

final class LaunchScreenSnapshotTests: XCTestCase {
    var sut: UIViewController!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(identifier: "Pola")
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: bundle)
        sut = storyboard.instantiateInitialViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testView(on config: ViewImageConfig, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        assertSnapshot(matching: sut, as: .image(on: config), file: file, testName: testName, line: line)
    }

    // iPhone 5, 5s, 5c, SE
    func testViewOnIPhoneSE() {
        testView(on: .iPhoneSe)
    }

    // iPhone 6, 6s, 7, 8
    func testViewOnIPhone8() {
        testView(on: .iPhone8)
    }

    // iPhone 6+, 6s+, 7+, 8+
    func testViewOnIPhone8Plus() {
        testView(on: .iPhone8Plus)
    }

    // iPhone X, Xs, 11 Pro
    func testViewOnIPhoneX() {
        testView(on: .iPhoneX)
    }

    // iPhone Xr, 11
    func testViewOnIPhoneXr() {
        testView(on: .iPhoneXr)
    }

    // iPhone Xs Max, 11 Pro Max
    func testViewOnIPhoneXsMax() {
        testView(on: .iPhoneXsMax)
    }
}
