import Firebase
import Swinject

final class AnalyticsRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        if FirebaseApp.isFirebaseAvailable {
            container.register(AnalyticsProvider.self) { _ in
                FirebaseAnalyticsProvider()
            }.inObjectScope(.container)
        } else {
            container.register(AnalyticsProvider.self) { _ in
                ConsoleAnalyticsProvider()
            }.inObjectScope(.container)
        }
    }
}
