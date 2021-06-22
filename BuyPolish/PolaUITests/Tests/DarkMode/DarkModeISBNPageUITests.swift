import XCTest

class DarkModeISBNPageUITests: PolaDarkModeUITestCase {
    func testISBNPage() {
        startingPageObject
            .enterCodeAndOpenISBNResult()
            .done()

        snapshotVerifyView()
    }
}
