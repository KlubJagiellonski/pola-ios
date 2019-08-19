import XCTest

class CompanyPagePolaFriendsUITests: PolaUITestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testGustawCompanyShouldBeMarkedAsPolaFriends() {
        let isPolaFriend =
            goToCompanyPage(company: Company.Gustaw)
                .isPolaFriend
        
        XCTAssertTrue(isPolaFriend)
        snapshotVerifyView()
    }
    
    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        let isPolaFriend =
            goToCompanyPage(company: Company.Staropramen)
                .isPolaFriend
        
        XCTAssertFalse(isPolaFriend)
        snapshotVerifyView()
    }
    
    func goToCompanyPage(company: Company) -> CompanyPage {
        return startingPageObject
                .tapEnterBarcodeButton()
                .inputBarcode(company.barcode)
                .tapOkButton()
                .waitForResultPageAndTap(companyName: company.name)
    }

}
