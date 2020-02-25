import XCTest

class TeachPolaPage: BasePage {
    
    let openFrom: ScanBarcodeWithResultsPage
    
    init(openFrom: ScanBarcodeWithResultsPage) {
        self.openFrom = openFrom
        super.init(app: openFrom.app)
    }

    func tapCloseButton() -> ScanBarcodeWithResultsPage {
        app.buttons["Zamknij"].firstMatch.tap()
        return openFrom
    }
        
}
