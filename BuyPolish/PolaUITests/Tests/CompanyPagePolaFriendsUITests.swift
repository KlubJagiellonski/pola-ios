import XCTest

class CompanyPagePolaFriendsUITests: PolaUITestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testGustawCompanyShouldBeMarkedAsPolaFriends() {
        let isPolaFriend =
            startingPageObject
                .enterCodeAndOpenCompanyResult(codeData: CodeData.Gustaw)
                .isPolaFriend
        
        XCTAssertTrue(isPolaFriend)
        snapshotVerifyView()
    }
    
    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        let isPolaFriend =
            startingPageObject
                .enterCodeAndOpenCompanyResult(codeData: CodeData.Staropramen)
                .isPolaFriend
        
        XCTAssertFalse(isPolaFriend)
        snapshotVerifyView()
    }
    
    func testKoralCompanyShouldShowAskForPicsButton() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Koral)
            .done()
        
        snapshotVerifyView()
    }
    
}
