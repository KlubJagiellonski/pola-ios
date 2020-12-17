import XCTest

class ScanBarcodePage: BasePage {
    func tapEnterBarcodeButton() -> EnterBarcodePage {
        app.buttons["Wpisz kod kreskowy"].tap()
        return EnterBarcodePage(app: app)
    }

    func tapInformationButton() -> InformationPage {
        app.buttons["Informacje o aplikacji"].tap()
        _ = app.staticTexts["OCEŃ NAS"].waitForExistence(timeout: waitForExistanceTimeout)
        return InformationPage(openFrom: self)
    }
    
    func isReviewRequestVisible() -> Bool {
        let element = app.scrollViews.otherElements.containing(.staticText, identifier: "Podoba Ci się aplikacja „Pola”?").element
        return element.waitForExistence(timeout: 10)
    }
}
