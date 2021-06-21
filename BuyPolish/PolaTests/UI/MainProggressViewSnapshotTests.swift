@testable import Pola
import SnapshotTesting
import XCTest

class MainProggressViewSnapshotTests: XCTestCase {
    var sut: MainProggressView!

    override func setUp() {
        super.setUp()
        sut = MainProggressView(frame: .zero)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testView(progress: CGFloat, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        sut.progress = progress
        sut.sizeToFit()
        sut.frameSize = CGSize(width: 100, height: sut.frameSize.height)

        assertSnapshot(matching: sut, as: .image, file: file, testName: testName, line: line)
    }

    func testView_whenProgressIs0() {
        testView(progress: 0)
    }

    func testView_whenProgressIs0dot1() {
        testView(progress: 0.1)
    }

    func testView_whenProgressIs0dot5() {
        testView(progress: 0.5)
    }

    func testView_whenProgressIs1() {
        testView(progress: 1)
    }

    @available(iOS 13.0, *)
    func testView_whenProgressIs0_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(progress: 0)
    }

    @available(iOS 13.0, *)
    func testView_whenProgressIs0dot1_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(progress: 0.1)
    }

    @available(iOS 13.0, *)
    func testView_whenProgressIs0dot5_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(progress: 0.5)
    }

    @available(iOS 13.0, *)
    func testView_whenProgressIs1_dark() {
        sut.overrideUserInterfaceStyle = .dark
        testView(progress: 1)
    }
}
