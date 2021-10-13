import Firebase
import Swinject

final class LoggerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(LoggerProvider.self) { _ in
            CrashlitycsLogger()
        }.inObjectScope(.container)
    }
}
