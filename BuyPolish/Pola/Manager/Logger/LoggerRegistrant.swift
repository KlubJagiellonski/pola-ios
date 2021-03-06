import Firebase
import Swinject

final class LoggerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        if FirebaseApp.isFirebaseAvailable {
            container.register(LoggerProvider.self) { _ in
                CrashlitycsLogger()
            }.inObjectScope(.container)
        } else {
            container.register(LoggerProvider.self) { _ in
                ConsoleLogger()
            }.inObjectScope(.container)
        }
    }
}
