import XCTest

final class CompanyPageUITests: PolaUITestCase {
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

    func testKoralCompanyShouldShowAskForDonateButton() {
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

    func testTapReportButton() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Koral)
            .tapReportButton()
            .done()

        snapshotVerifyView()
    }


    func testLongNameCollapsed() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Krasnystaw)
            .done()

        snapshotVerifyView()
    }
}
