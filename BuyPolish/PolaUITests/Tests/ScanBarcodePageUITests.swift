import XCTest

final class ScanBarcodePageUITests: PolaUITestCase {
    private var page: ScanBarcodePage!

    override func setUp() {
        super.setUp()
        continueAfterFailure = true

        page = startingPageObject
    }

    override func tearDown() {
        page = nil
        super.tearDown()
    }

    func testOpenApp() {
        snapshotVerifyView()
    }

    private func isGalleryVisible() -> Bool {
        page.app.navigationBars["Photos"].waitForExistence(timeout: 10)
    }

    func testTapGalleryButton() {
        _ = startingPageObject
            .tapGalleryButton()

        XCTAssertTrue(isGalleryVisible())
    }
}
