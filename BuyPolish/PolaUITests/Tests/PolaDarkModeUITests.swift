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

    func testEnterBarcodePage() {
        startingPageObject
            .tapEnterBarcodeButton()
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
}
