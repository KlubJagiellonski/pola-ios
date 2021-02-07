@testable import Pola
import SnapshotTesting
import XCTest

final class CompanyContentViewControllerSnapshotTests: XCTestCase {
    func test_whenResultIsRadziemska() {
        testView(data: .Radziemska)
    }

    func test_whenResultIsGustaw() {
        testView(data: .Gustaw)
    }

    func test_whenResultIsKoral() {
        testView(data: .Koral)
    }

    func test_whenResultIsLomza() {
        testView(data: .Lomza)
    }

    func test_whenResultIsNaleczowianka() {
        testView(data: .Naleczowianka)
    }

    func test_whenResultIsStaropramen() {
        testView(data: .Staropramen)
    }

    private func testView(data: CodeData, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = CompanyContentViewController(result: data.scanResult)

        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
