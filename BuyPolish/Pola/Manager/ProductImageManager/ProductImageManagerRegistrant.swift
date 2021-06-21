import Swinject

final class ProductImageManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ProductImageManager.self) { resolver in
            LocalDocumentsProductImageManager(fileManager: resolver.resolve(FileManager.self)!)
        }
    }
}
