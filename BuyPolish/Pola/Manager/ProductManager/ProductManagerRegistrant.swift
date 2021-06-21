import Foundation
import Swinject

final class ProductManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ProductManager.self) { resolver in
            ProductManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!)
        }
    }
}
