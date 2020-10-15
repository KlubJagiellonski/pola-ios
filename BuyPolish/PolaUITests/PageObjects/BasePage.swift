import XCTest

class BasePage {
    let app: XCUIApplication
    var waitForExistanceTimeout = TimeInterval(10)

    var pasteboard: String? {
        get {
            UIPasteboard.general.strings?.first
        }
        set {
            UIPasteboard.general.strings = newValue != nil ? [newValue!] : []
        }
    }

    init(app: XCUIApplication) {
        self.app = app
    }

    func done() {}

    func setPasteboard(_ pasteboard: String?) -> Self {
        self.pasteboard = pasteboard
        return self
    }
}
