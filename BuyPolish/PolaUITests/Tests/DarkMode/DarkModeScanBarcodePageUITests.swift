import XCTest

class DarkModeScanBarcodePageUITests: PolaDarkModeUITestCase {
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
}
