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

    func testKoralCompanyShouldNotShowReportButton() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: .Koral)
            .done()

        snapshotVerifyView()
    }

    func testOwnBrand() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: .Lidl)
            .done()

        snapshotVerifyView()
    }

    func testTapReportButton() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: .Radziemska)
            .tapReportButton()
            .done()

        snapshotVerifyView()
    }

    func testLongName() throws {
        throw skipTest(issueNumber: 206)
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: .Krasnystaw)
            .done()

        snapshotVerifyView()
    }
}
