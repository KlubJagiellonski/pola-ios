@testable import Pola

class AnalyticsProviderMock: AnalyticsProvider {
    var lastEventName: String?
    var lastEventParameters: [String: String]?

    func configure() {}

    func logEvent(name: String, parameters: [String: String]?) {
        lastEventName = name
        lastEventParameters = parameters
    }
}
