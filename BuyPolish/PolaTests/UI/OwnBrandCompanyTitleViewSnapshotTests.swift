@testable import Pola
import SnapshotTesting
import XCTest

class OwnBrandCompanyTitleViewSnapshotTests: XCTestCase {
    var sut: OwnBrandCompanyTitleView!

    override func setUp() {
        super.setUp()
        sut = OwnBrandCompanyTitleView(frame: .zero)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func verifyView(file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        sut.layoutSubviews()
        sut.sizeToFit()

        assertSnapshot(matching: sut, as: .image, file: file, testName: testName, line: line)
    }

    func testView_whenCompanyHave10Points() {
        sut.title = "LIDL Polska Sp z o.o."
        sut.progress = 0.1
        verifyView()
    }

    func testView_whenCompanyHave100Points() {
        sut.title = "TYMBARK - MWS Sp z o.o."
        sut.progress = 1
        verifyView()
    }
}
