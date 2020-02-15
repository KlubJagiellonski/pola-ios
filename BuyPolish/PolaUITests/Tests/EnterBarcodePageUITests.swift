import XCTest

class EnterBarcodePageUITests: PolaUITestCase {
    
    private var page: EnterBarcodePage!

    override func setUp() {
        super.setUp()
        recordMode = false
        
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
    
    func testEnterInvalidBarcodeAndConfirm(){
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

}
