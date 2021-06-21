import Firebase

extension FirebaseApp {
    static var isFirebaseAvailable: Bool {
        return Bundle(for: FirebaseAnalyticsProvider.self).path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }
}
