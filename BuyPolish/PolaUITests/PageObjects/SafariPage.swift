import XCTest

final class SafariPage: BasePage {
    let openFrom: BasePage

    init(openFrom: BasePage) {
        self.openFrom = openFrom
        super.init(app: XCUIApplication(bundleIdentifier: "com.apple.mobilesafari"))
    }

    var url: String {
        app.buttons["URL"].tap()
        let urlTextField = app.textFields["URL"]
        let value = urlTextField.value
        return value as! String
    }

    func returnToApp() -> BasePage {
        openFrom.app.activate()
        return openFrom
    }
}
