import Firebase
import Foundation

final class FirebaseAnalyticsProvider: AnalyticsProvider {
    func configure() {
        FirebaseApp.configure()
    }

    func logEvent(name: String, parameters: [String: String]?) {
        Analytics.logEvent(name, parameters: parameters)
        Crashlytics.crashlytics().log("\(name): \(parameters ?? [:])")
    }
}
