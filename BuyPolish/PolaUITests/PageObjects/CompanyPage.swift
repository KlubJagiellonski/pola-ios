import Foundation

final class CompanyPage: ResultPage {
    func tapReportButton() -> ReportBugPage {
        app.buttons["ZGŁOŚ"].tap()
        return ReportBugPage(app: app)
    }

    func swipeToCollapse() -> ScanBarcodePage {
        app.swipeDown()
        return ScanBarcodePage(app: app)
    }
}
