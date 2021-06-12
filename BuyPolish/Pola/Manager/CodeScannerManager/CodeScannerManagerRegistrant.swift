import Foundation
import Swinject

final class CodeScannerManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(CodeScannerManager.self) { _ in
            CameraSessionCodeScannerManager()
        }
    }
}
