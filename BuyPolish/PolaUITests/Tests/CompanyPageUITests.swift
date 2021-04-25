import XCTest

final class CompanyPageUITests: PolaUITestCase {
    func testRadziemskaCompanyShouldBeMarkedAsPolaFriends() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Radziemska)
            .done()

        snapshotVerifyView()
    }

    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Staropramen)
            .done()

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

    func testLongName() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Krasnystaw)
            .done()

        snapshotVerifyView()
    }
}
