import XCTest

final class ISBNPageUITests: PolaUITestCase {
    func testISBNPage() {
        startingPageObject
            .enterCodeAndOpenISBNResult()
            .done()

        snapshotVerifyView()
    }
}
