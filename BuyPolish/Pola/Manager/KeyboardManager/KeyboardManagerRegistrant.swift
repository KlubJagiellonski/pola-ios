import Foundation
import Swinject

final class KeyboardManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(KeyboardManager.self) { resolver in
            NotificationCenterKeyboardManager(notificationCenter: resolver.resolve(NotificationCenter.self)!)
        }
    }
}
