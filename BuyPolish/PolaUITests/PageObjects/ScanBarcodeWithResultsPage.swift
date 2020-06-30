import XCTest

final class ScanBarcodeWithResultsPage: ScanBarcodePage {
    let newestResult: String

    init(app: XCUIApplication, result: String) {
        newestResult = result
        super.init(app: app)
    }

    func tapOnNewestResultCard<T: ResultPage>(expectedResultType _: T.Type) -> T {
        app.staticTexts[newestResult].tap()
        return T(app: app)
    }

    func tapDonatePolaButton() -> SafariPage {
        app.staticTexts["Wspieraj aplikację Pola"].firstMatch.tap()
        return SafariPage(openFrom: self)
    }
}
