@testable import Pola

class MockAnalyticsProvider: AnalyticsProvider {
    func configure() {}

    func logEvent(name _: String, parameters _: [String: String]?) {}
}
