import XCTest

class ISBNPageUITests: PolaUITestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testISBNPage() {
        startingPageObject
            .tapEnterBarcodeButton()
            .inputBarcode(ISBNCode)
            .tapOkButton()
            .waitForISBNResultPageAndTap()
            .done()

        snapshotVerifyView()
    }
    
}
