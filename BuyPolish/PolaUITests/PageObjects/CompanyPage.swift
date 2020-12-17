import Foundation

final class CompanyPage: ResultPage {
    var isPolaFriend: Bool {
        return app.buttons["To jest przyjaciel Poli"].waitForExistence(timeout: waitForExistanceTimeout)
    }

    func tapReportButton() -> ReportBugPage {
        app.buttons["ZGŁOŚ"].tap()
        return ReportBugPage(app: app)
    }

    func tapToCollapse() -> ScanBarcodePage {
        app.scrollViews.otherElements.staticTexts["udział polskiego kapitału"].firstMatch.tap()
        return ScanBarcodePage(app: app)
    }
}
