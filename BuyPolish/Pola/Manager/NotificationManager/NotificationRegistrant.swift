import Firebase
import Swinject

final class NotificationRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(NotificationProvider.self) { _ in
            NotificationManager()
        }.inObjectScope(.container)
    }
}
