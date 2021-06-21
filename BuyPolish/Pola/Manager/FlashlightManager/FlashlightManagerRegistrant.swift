import Foundation
import Swinject

final class FlashlightManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(FlashlightManager.self) { _ in
            FlashlightManager()
        }
    }
}
