import XCTest

class BasePage {
    let app: XCUIApplication
    var waitForExistanceTimeout = TimeInterval(10)

    init(app: XCUIApplication) {
        self.app = app
    }

    func done() {}
}
