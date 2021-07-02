@testable import Pola
import SnapshotTesting
import XCTest

final class AltResultContentViewControllerSnapshotTests: XCTestCase {
    func test_whenResultIsISBN() {
        testView(data: .ISBN)
    }

    func test_whenResultIsISBN_dark() {
        testView(data: .ISBN, enableDarkMode: true)
    }

    private func testView(data: CodeData, enableDarkMode: Bool = false, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = AltResultContentViewController(result: data.scanResult)

        if enableDarkMode, #available(iOS 13.0, *) {
            sut.overrideUserInterfaceStyle = .dark
        }
        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
