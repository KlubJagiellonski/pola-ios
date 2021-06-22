import XCTest

class DarkModeEnterBarcodePageUITests: PolaDarkModeUITestCase {
    private var page: EnterBarcodePage!

    override func setUp() {
        super.setUp()
        page = startingPageObject.tapEnterBarcodeButton().setPasteboard(nil)
    }

    override func tearDown() {
        page = nil

        super.tearDown()
    }

    func testOpenEnterBarcodePage() {
        snapshotVerifyView()
    }

    func testEnterBarcodeShouldSetTextInTextfield() {
        page.inputBarcode("1234567890")
            .done()

        snapshotVerifyView()
    }

    func testEnterInvalidBarcodeAndConfirm() {
        page.inputBarcode("1234567890123")
            .tapOkButton()
            .waitForErrorMessage()
            .done()

        snapshotVerifyView()
    }

    func testConfirmWithoutBarcode() {
        page.tapOkButton()
            .waitForErrorMessage()
            .done()

        snapshotVerifyView()
    }

    func testContextMenu_whenNothingIsTypedAndPasteboardIsClear() {
        page.longTapOnBarcodeLabel().done()

        snapshotVerifyView()
    }

    func testContextMenu_whenSomethingIsTyped() {
        page.inputBarcode("12345").longTapOnBarcodeLabel().done()

        snapshotVerifyView()
    }
}
