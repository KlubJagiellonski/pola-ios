import XCTest

final class ScanBarcodeWithResultPageUITests: PolaUITestCase {
    override func setUp() {
        super.setUp()
    }

    func testGustawCompanyShouldBeMarkedAsPolaFriends() {
        testResultPage(codeData: CodeData.Gustaw)
    }

    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        testResultPage(codeData: CodeData.Staropramen)
    }

    func testKoralCompanyShouldShowAskForDonateButton() {
        testResultPage(codeData: CodeData.Koral)
    }

    func testISBNCode() {
        testResultPage(codeData: CodeData.ISBN)
    }

    func testResultPage(codeData: CodeData, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        startingPageObject.enterCodeAndWaitForResult(codeData: codeData, file: file, line: line).done()

        snapshotVerifyView(file: file, testName: testName, line: line)
    }

    func testMultiplyResultPages() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Tymbark)
            .enterCodeAndWaitForResult(codeData: CodeData.Lomza)
            .enterCodeAndWaitForResult(codeData: CodeData.Gustaw)
            .done()

        snapshotVerifyView()
    }

    func testDoubleScanSameCodeShouldShowOneResult() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Gustaw)
            .enterCodeAndWaitForResult(codeData: CodeData.Gustaw)
            .done()

        snapshotVerifyView()
    }

    func testRequestReview() {
        let result = startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Gustaw)
            .enterCodeAndWaitForResult(codeData: CodeData.Koral)
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Naleczowianka)
            .swipeToCollapse()
            .isReviewRequestVisible()

        XCTAssert(result, "Application rating alert did not appear")
    }

    func testLongNameCollapsed() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Krasnystaw)
            .done()

        snapshotVerifyView()
    }
}
