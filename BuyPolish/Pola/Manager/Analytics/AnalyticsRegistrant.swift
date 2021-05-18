import Firebase
import Swinject

final class AnalyticsRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        if FirebaseApp.isFirebaseAvailable {
            container.register(AnalyticsProvider.self) { _ in
                FirebaseAnalyticsProvider()
            }
        } else {
            container.register(AnalyticsProvider.self) { _ in
                ConsoleAnalyticsProvider()
            }
        }
    }
}
