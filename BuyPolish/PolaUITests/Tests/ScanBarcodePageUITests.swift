import XCTest

final class ScanBarcodePageUITests: PolaUITestCase {
    func testOpenApp() {
        snapshotVerifyView()
    }

    func testTapGalleryButton() {
        startingPageObject
            .tapGalleryButton()
            .wait(time: 10)
            .done()

        snapshotVerifyView()
    }
}
