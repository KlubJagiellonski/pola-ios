@testable import Pola
import SnapshotTesting
import XCTest

final class AltResultContentViewControllerSnapshotTests: XCTestCase {
    func test_whenResultIsISBN() {
        testView(data: .ISBN)
    }

    private func testView(data: CodeData, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = AltResultContentViewController(result: data.scanResult)

        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
