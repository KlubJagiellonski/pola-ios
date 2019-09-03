import XCTest

class InformationPageUITests: PolaUITestCase {
    
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
    
    func testFacebookShouldOpenPolaFacebookInSafari() {
        let safariPage = page.tapFacebookButton()
        let url = safariPage.url
        safariPage.returnToApp().done()

        XCTAssertTrue(url.contains("facebook.com/app.pola"))
    }
    
    func testTwitterShouldOpenPolaTwitterInSafari() {
        let safariPage = page.tapTwitterButton()
        let url = safariPage.url
        safariPage.returnToApp().done()

        XCTAssertTrue(url.contains("twitter.com/pola_app"))
    }

}
