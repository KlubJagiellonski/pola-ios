import XCTest

final class EnterBarcodePageUITests: PolaUITestCase {
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

    func testEnterBarcodeLongerThan13DigitsShouldInputOnlyFirst13Digits() {
        page.inputBarcode("12345678901234567890")
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

    func testDeleteButtonShouldDeleteLastDigit() {
        page.inputBarcode("1234567890")
            .tapDeleteButton()
            .done()

        snapshotVerifyView()
    }

    func testContextMenu_whenNothingIsTypedAndPasteboardIsClear() {
        page.longTapOnBarcodeLabel().done()

        snapshotVerifyView()
    }

    func testContextMenu_whenNothingIsTypedAndPasteboardIsNotClear() throws {
        throw skipTest(issueNumber: 151)
        page.setPasteboard("123456")
            .longTapOnBarcodeLabel()
            .waitForPasteboardInfoDissappear()
            .wait(time: 20)
            .done()

        snapshotVerifyView()
    }

    func testContextMenu_whenSomethingIsTyped() {
        page.inputBarcode("12345").longTapOnBarcodeLabel().done()

        snapshotVerifyView()
    }

    func testPaste() {
        page.setPasteboard("123456789")
            .longTapOnBarcodeLabel()
            .tapPasteAction()
            .waitForPasteActionDisappear()
            .done()

        snapshotVerifyView()
    }

    func testPasteAndActivate() {
        page.setPasteboard("123456789")
            .longTapOnBarcodeLabel()
            .tapPasteAndActivateAction()
            .waitForPasteActionDisappear()
            .done()

        snapshotVerifyView()
    }

    func testDelete() {
        page.inputBarcode("12345")
            .longTapOnBarcodeLabel()
            .tapDeleteAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
    }

    func testCut() {
        let input = "12345"
        page.inputBarcode(input)
            .longTapOnBarcodeLabel()
            .tapCutAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
        XCTAssertEqual(page.pasteboard, input)
    }

    func testCopy() {
        let input = "12345"
        page.inputBarcode(input)
            .longTapOnBarcodeLabel()
            .tapCopyAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
        XCTAssertEqual(page.pasteboard, input)
    }
}
