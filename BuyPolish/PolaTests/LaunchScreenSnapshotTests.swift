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

    // iPhone 5, 5s, 5c, SE
    @available(iOS 13.0, *)
    func testViewOnIPhoneSE_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhoneSe)
    }

    // iPhone 6, 6s, 7, 8
    @available(iOS 13.0, *)
    func testViewOnIPhone8_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhone8)
    }

    // iPhone 6+, 6s+, 7+, 8+
    @available(iOS 13.0, *)
    func testViewOnIPhone8Plus_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhone8Plus)
    }

    // iPhone X, Xs, 11 Pro
    @available(iOS 13.0, *)
    func testViewOnIPhoneX_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhoneX)
    }

    // iPhone Xr, 11
    @available(iOS 13.0, *)
    func testViewOnIPhoneXr_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhoneXr)
    }

    // iPhone Xs Max, 11 Pro Max
    @available(iOS 13.0, *)
    func testViewOnIPhoneXsMax_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(on: .iPhoneXsMax)
    }
}
