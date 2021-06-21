import Swinject
import UIKit

final class UIKitRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(UIDevice.self) { _ in
            UIDevice.current
        }
    }
}
