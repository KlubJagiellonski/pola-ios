import Foundation

final class InformationPage: BasePage {
    let openFrom: BasePage

    init(openFrom: BasePage) {
        self.openFrom = openFrom
        super.init(app: openFrom.app)
    }

    func tapCloseButton() -> BasePage {
        app.navigationBars["Informacje"].buttons["Zamknij"].tap()
        return openFrom
    }

    func tapReportBugButton() -> ReportBugPage {
        app.tables.staticTexts["ZGŁOŚ BŁĄD DANYCH"].tap()
        return ReportBugPage(app: app)
    }

    func tapFacebookButton() -> SafariPage {
        app.tables.buttons["FACEBOOK"].tap()
        return SafariPage(openFrom: self)
    }

    func tapTwitterButton() -> SafariPage {
        app.tables.buttons["TWITTER"].tap()
        return SafariPage(openFrom: self)
    }
}
