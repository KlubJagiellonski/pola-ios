import Swinject

final class RequestFactoryRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(DataRequestFactory.self) { resolver in
            PolaRequestFactory(processInfo: resolver.resolve(ProcessInfo.self)!,
                               device: resolver.resolve(UIDevice.self)!)
        }

        container.register(MediaUploadRequestFactory.self) { _ in
            PutAmazonRequestFactory()
        }
    }
}
