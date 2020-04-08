import XCTest

final class InformationPageUITests: PolaUITestCase {
    
    var page: InformationPage!

    override func setUp() {
        super.setUp()
        recordMode = false
        
        page = startingPageObject.tapInformationButton()
    }

    override func tearDown() {
        page = nil
    }
    
    func testOpenInformationPage() {
        snapshotVerifyView()
    }
    
    func testCloseInformationPage() {
        page.tapCloseButton().done()
        
        snapshotVerifyView()
    }
}
