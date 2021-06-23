import XCTest

class DarkModeScanBarcodeWithResultPageUITests: PolaDarkModeUITestCase {
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

    func testLongNameCollapsed() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: CodeData.Krasnystaw)
            .done()

        snapshotVerifyView()
    }
}
