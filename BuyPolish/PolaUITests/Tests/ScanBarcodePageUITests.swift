import XCTest

final class ScanBarcodePageUITests: PolaUITestCase {
    private var page: ScanBarcodePage!

    override func setUp() {
        super.setUp()

        page = startingPageObject
    }

    override func tearDown() {
        page = nil
        super.tearDown()
    }

    func testOpenApp() {
        snapshotVerifyView()
    }

    func testTapGalleryButton() {
        let isGalleryVisible = startingPageObject
            .tapGalleryButton()
            .isGalleryVisible()

        XCTAssertTrue(isGalleryVisible)
    }
}
