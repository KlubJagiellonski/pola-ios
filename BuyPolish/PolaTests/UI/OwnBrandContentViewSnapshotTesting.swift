@testable import Pola
import SnapshotTesting
import XCTest

class OwnBrandContentViewSnapshotTesting: XCTestCase {
    var sut: OwnBrandContentView!

    override func setUp() {
        super.setUp()
        sut = OwnBrandContentView(frame: .zero)
        sut.addConstraint(sut.widthAnchor.constraint(equalToConstant: 230))
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

    func testView() {
        verifyView()
    }
}
