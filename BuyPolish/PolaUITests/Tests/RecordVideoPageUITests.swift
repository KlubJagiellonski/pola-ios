import XCTest

class RecordVideoPageUITests: PolaUITestCase {
    var page: RecordVideoPage!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        
        page = startingPageObject
            .enterCodeAndWaitForResult(codeData: .Naleczowianka)
            .tapHelpPolaButton()
            .tapRecordVideoButton()
    }
    
    func testOpenPage() {
        snapshotVerifyView()
    }
    
    func testTapStart() {
        page.tapStartButton().done()
        
        snapshotVerifyView()
    }
    
    func testTimerAfterStart() {
        page.tapStartButton()
            .waitForTimerLabel(seconds: 4)
            .done()
        
        snapshotVerifyView()
    }

}
