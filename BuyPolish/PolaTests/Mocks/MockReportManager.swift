@testable import Pola
import PromiseKit

class MockReportManager: ReportManager {
    func send(report _: Report) -> Promise<Void> {
        return Promise()
    }
}
