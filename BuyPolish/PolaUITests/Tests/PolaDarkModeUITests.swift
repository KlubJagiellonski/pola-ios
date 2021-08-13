import SnapshotTesting
import XCTest

class PolaDarkModeUITests: PolaUITestCase {
    override func setUp() {
        appLaunchArguments += ["--enableDarkMode"]
        super.setUp()
    }

    func testScanBarcodePage() {
        snapshotVerifyView()
    }

    func testScanBarcodeWithResultsPage() {
        startingPageObject
            .enterCodeAndWaitForResult(codeData: .Krasnystaw)
            .done()

        snapshotVerifyView()
    }

    func testCompanyPage() {
        startingPageObject
            .enterCodeAndOpenCompanyResult(codeData: CodeData.Lidl)
            .done()

        snapshotVerifyView()
    }

    func testISBNPage() {
        startingPageObject
            .enterCodeAndOpenISBNResult()
            .done()

        snapshotVerifyView()
    }

    func testReportBugPage() {
        startingPageObject
            .tapInformationButton()
            .tapReportBugButton()
            .done()

        snapshotVerifyView()
    }

    func testEnterBarcodePage() throws {
        throw skipTest(issueNumber: 248)
        startingPageObject
            .tapEnterBarcodeButton()
            .done()

        snapshotVerifyView()
    }

    func testInformationPage() {
        startingPageObject
            .tapInformationButton()
            .done()

        snapshotVerifyView()
    }
}
