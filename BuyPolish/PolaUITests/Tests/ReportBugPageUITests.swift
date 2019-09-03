import XCTest

class ReportBugPageUITests: PolaUITestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testOpenReportBugPage() {
        startingPageObject
            .tapInformationButton()
            .tapReportBugButton()
            .done()
        
        snapshotVerifyView()
    }

}
