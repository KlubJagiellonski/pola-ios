import Firebase
import Swinject

final class AnalyticsRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(AnalyticsProvider.self) { _ in
            FirebaseAnalyticsProvider()
        }.inObjectScope(.container)
    }
}
