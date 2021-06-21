import Foundation

final class ConsoleAnalyticsProvider: AnalyticsProvider {
    func configure() {}

    func logEvent(name: String, parameters: [String: String]?) {
        print("AnalyticsEvent: \(name)")
        if let parameters = parameters {
            print("parameters: \(parameters)")
        }
    }
}
