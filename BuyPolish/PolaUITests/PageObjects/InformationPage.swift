import Foundation

class InformationPage: BasePage {
    
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
