@testable import Pola
import SnapshotTesting
import XCTest

class OwnBrandContentViewSnapshotTesting: XCTestCase {
    func testView_whenResultIsLidl() {
        testView(data: .Lidl)
    }

    private func testView(data: CodeData, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = OwnBrandContentViewController(result: data.scanResult)

        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
