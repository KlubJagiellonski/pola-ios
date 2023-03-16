import Swinject

final class ApplicationShortcutRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ApplicationShortcutHandling.self) { _ in
            ApplicationShortcutHandler()
        }.inObjectScope(.container)
    }
}
