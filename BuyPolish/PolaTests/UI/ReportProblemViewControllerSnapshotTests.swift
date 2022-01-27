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

    @available(iOS 13, *)
    func test_whenDisabledImages_dark() {
        let sut = vc(isImageEnabled: false)
        sut.overrideUserInterfaceStyle = .dark
        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

    @available(iOS 13, *)
    func test_whenEnabledImages_dark() {
        let sut = vc(isImageEnabled: true)
        sut.overrideUserInterfaceStyle = .dark
        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

    func vc(isImageEnabled: Bool) -> ReportProblemViewController {
        let imageManagerMock = ProductImageManagerMock()
        imageManagerMock.retrieveThumbnailsForReturnValue = []
        return ReportProblemViewController(
            reason: .general,
            productImageManager: imageManagerMock,
            reportManager: ReportManagerMock(),
            keyboardManager: KeyboardManagerMock(),
            analyticsProvider: AnalyticsProviderMock(),
            isImageEnabled: isImageEnabled
        )
    }
}
