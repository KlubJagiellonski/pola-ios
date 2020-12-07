import Firebase
import Foundation

final class FirebaseAnalyticsProvider: AnalyticsProvider {
    func configure() {
        if firebaseAvailable {
            FirebaseApp.configure()
        }
    }

    func logEvent(name: String, parameters: [String: String]?) {
        guard firebaseAvailable else {
            return
        }
        Analytics.logEvent(name, parameters: parameters)
        Crashlytics.crashlytics().log("\(name): \(parameters ?? [:])")
    }

    private var firebaseAvailable: Bool {
        return Bundle(for: type(of: self)).path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }
}
