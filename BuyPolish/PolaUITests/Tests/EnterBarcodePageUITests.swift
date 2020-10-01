import XCTest

final class EnterBarcodePageUITests: PolaUITestCase {
    private var page: EnterBarcodePage!

    private var pasteboard: String? {
        get {
            UIPasteboard.general.strings?.first
        }
        set {
            UIPasteboard.general.strings = newValue != nil ? [newValue!] : []
        }
    }

    override func setUp() {
        super.setUp()
        recordMode = false

        pasteboard = nil
        page = startingPageObject.tapEnterBarcodeButton()
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
        page.longTapOnBarcodeLabe().done()

        snapshotVerifyView()
    }

    func testContextMenu_whenNothingIsTypedAndPasteboardIsNotClear() {
        pasteboard = "123456"
        page.longTapOnBarcodeLabe().done()

        snapshotVerifyView()
    }

    func testContextMenu_whenSomethingIsTyped() {
        page.inputBarcode("12345").longTapOnBarcodeLabe().done()

        snapshotVerifyView()
    }

    func testPaste() {
        pasteboard = "123456789"
        page.longTapOnBarcodeLabe()
            .tapPasteAction()
            .waitForPasteActionDisappear()
            .done()

        snapshotVerifyView()
    }

    func testDelete() {
        page.inputBarcode("12345")
            .longTapOnBarcodeLabe()
            .tapDeleteAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
    }

    func testCut() {
        let input = "12345"
        page.inputBarcode(input)
            .longTapOnBarcodeLabe()
            .tapCutAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
        XCTAssertEqual(pasteboard, input)
    }

    func testCopy() {
        let input = "12345"
        page.inputBarcode(input)
            .longTapOnBarcodeLabe()
            .tapCopyAction()
            .waitForDeleteActionDisappear()
            .done()

        snapshotVerifyView()
        XCTAssertEqual(pasteboard, input)
    }
}
