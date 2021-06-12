import Foundation
import Swinject

final class FoundationRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }

        container.register(ProcessInfo.self) { _ in
            ProcessInfo.processInfo
        }

        container.register(FileManager.self) { _ in
            FileManager.default
        }
    }
}
