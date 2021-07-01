import Swinject

final class CapturedImageManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(CapturedImageManager.self) { _ in
            InMemoryCapturedImageManager()
        }
    }
}
