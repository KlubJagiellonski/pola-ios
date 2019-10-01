import XCTest

class ScanBarcodeWithResultsPage: ScanBarcodePage {
    let newestResult: String
    
    init(app: XCUIApplication, result: String) {
        self.newestResult = result
        super.init(app: app)
    }
    
    func tapOnNewestResultCard<T: ResultPage>(expectedResultType: T.Type) -> T {
        app.staticTexts[newestResult].tap()
        return T(app: app)
    }
    
}
