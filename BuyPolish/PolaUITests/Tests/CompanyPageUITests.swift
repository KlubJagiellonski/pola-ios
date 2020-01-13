import XCTest

class CompanyPageUITests: PolaUITestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testRadziemskaCompanyShouldBeMarkedAsPolaFriends() {
        let isPolaFriend =
            startingPageObject
                .enterCodeAndOpenCompanyResult(codeData: CodeData.Radziemska)
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
    
    func testNaleczowiankaCompanyShouldHas0PolishCapital() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Naleczowianka)
            .done()
        
        snapshotVerifyView()
    }
    
}
