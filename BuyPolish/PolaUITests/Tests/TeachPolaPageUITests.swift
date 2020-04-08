import XCTest

final class TeachPolaPageUITests: PolaUITestCase {
    
    var page: TeachPolaPage!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        
        page = startingPageObject
            .enterCodeAndWaitForResult(codeData: .Naleczowianka)
            .tapHelpPolaButton()
    }
    
    func testOpenPage() {
        snapshotVerifyView()
    }
        
    func testTapClose() {
        page.tapCloseButton().done()
        
        snapshotVerifyView()
    }
    
}
