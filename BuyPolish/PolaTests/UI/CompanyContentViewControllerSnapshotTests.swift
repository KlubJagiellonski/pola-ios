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

    func test_whenResultIsRadziemska_dark() {
        testView(data: .Radziemska, enableDarkMode: true)
    }

    func test_whenResultIsGustaw_dark() {
        testView(data: .Gustaw, enableDarkMode: true)
    }

    func test_whenResultIsKoral_dark() {
        testView(data: .Koral, enableDarkMode: true)
    }

    func test_whenResultIsLomza_dark() {
        testView(data: .Lomza, enableDarkMode: true)
    }

    func test_whenResultIsNaleczowianka_dark() {
        testView(data: .Naleczowianka, enableDarkMode: true)
    }

    func test_whenResultIsStaropramen_dark() {
        testView(data: .Staropramen, enableDarkMode: true)
    }

    private func testView(data: CodeData, enableDarkMode: Bool = false, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = CompanyContentViewController(
            result: data.scanResult,
            analyticsProvider: AnalyticsProviderMock()
        )

        if enableDarkMode, #available(iOS 13.0, *) {
            sut.overrideUserInterfaceStyle = .dark
        }

        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
