import XCTest

class DarkModeInformationPageUITests: PolaDarkModeUITestCase {
    var page: InformationPage!

    override func setUp() {
        super.setUp()
        page = startingPageObject.tapInformationButton()
    }

    override func tearDown() {
        super.tearDown()
        page = nil
    }

    func testOpenInformationPage() {
        snapshotVerifyView()
    }

    func testCloseInformationPage() {
        page.tapCloseButton().done()

        snapshotVerifyView()
    }
}
