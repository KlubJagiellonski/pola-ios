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

    func waitForPasteboardInfoDissappear(file: StaticString = #file, line: UInt = #line) -> Self {
        let elements = [
            "Pola pasted from PolaUITests-Runner",
            "CoreSimulatorBridge pasted from Pola",
        ].map { app.staticTexts[$0] }
        if !elements.waitForDisappear(timeout: waitForExistanceTimeout) {
            XCTFail("Pasteboard info still visible", file: file, line: line)
        }

        return self
    }

    func wait(time: TimeInterval) -> Self {
        Thread.sleep(forTimeInterval: time)
        return self
    }
}
