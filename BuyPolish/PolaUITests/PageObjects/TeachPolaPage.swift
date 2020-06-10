import XCTest

final class TeachPolaPage: BasePage {
    let openFrom: ScanBarcodeWithResultsPage

    init(openFrom: ScanBarcodeWithResultsPage) {
        self.openFrom = openFrom
        super.init(app: openFrom.app)
    }

    func tapCloseButton() -> ScanBarcodeWithResultsPage {
        app.buttons["Zamknij"].firstMatch.tap()
        return openFrom
    }

    func tapRecordVideoButton() -> RecordVideoPage {
        app.buttons["Nakręć film"].firstMatch.tap()
        return RecordVideoPage(app: app)
    }
}
