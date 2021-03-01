@testable import Pola
import SnapshotTesting
import XCTest

class ReportProblemViewControllerSnapshotTests: XCTestCase {
    func test_whenDisabledImages() {
        let sut = vc(isImageEnabled: false)

        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

    func test_whenEnabledImages() {
        let sut = vc(isImageEnabled: true)

        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

    func vc(isImageEnabled: Bool) -> ReportProblemViewController {
        return ReportProblemViewController(
            reason: .general,
            productImageManager: MockProductImageManager(),
            reportManager: MockReportManager(),
            keyboardManager: MockKeyboardManager(),
            analyticsProvider: MockAnalyticsProvider(),
            isImageEnabled: isImageEnabled
        )
    }
}
