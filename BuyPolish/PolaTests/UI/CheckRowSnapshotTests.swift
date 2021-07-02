@testable import Pola
import SnapshotTesting
import XCTest

class CheckRowSnapshotTests: XCTestCase {
    var sut: CheckRow!

    override func setUp() {
        super.setUp()
        sut = CheckRow(frame: .zero)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func verifyView(file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        sut.sizeToFit()

        assertSnapshot(matching: sut, as: .image, file: file, testName: testName, line: line)
    }

    func testView_WhenCheckedIsNil() {
        sut.checked = nil
        verifyView()
    }

    func testView_WhenCheckedIsTrue() {
        sut.checked = true
        verifyView()
    }

    func testView_WhenCheckedIsFalse() {
        sut.checked = false
        verifyView()
    }

    func testView_WhenTextIsNotNil() {
        sut.text = "produkuje w Polsce"
        verifyView()
    }

    @available(iOS 13.0, *)
    func testView_WhenCheckedIsNil_dark() {
        sut.checked = nil
        sut.overrideUserInterfaceStyle = .dark
        verifyView()
    }

    @available(iOS 13.0, *)
    func testView_WhenCheckedIsTrue_dark() {
        sut.checked = true
        sut.overrideUserInterfaceStyle = .dark
        verifyView()
    }

    @available(iOS 13.0, *)
    func testView_WhenCheckedIsFalse_dark() {
        sut.checked = false
        sut.overrideUserInterfaceStyle = .dark
        verifyView()
    }

    @available(iOS 13.0, *)
    func testView_WhenTextIsNotNil_dark() {
        sut.text = "produkuje w Polsce"
        sut.overrideUserInterfaceStyle = .dark
        verifyView()
    }
}
