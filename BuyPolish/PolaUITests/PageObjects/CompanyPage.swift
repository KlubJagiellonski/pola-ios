import Foundation

final class CompanyPage: ResultPage {
    var isPolaFriend: Bool {
        return app.buttons["To jest przyjaciel Poli"].waitForExistence(timeout: waitForExistanceTimeout)
    }

    func tapReportButton() -> ReportBugPage {
        app.buttons["ZGŁOŚ"].tap()
        return ReportBugPage(app: app)
    }
}
