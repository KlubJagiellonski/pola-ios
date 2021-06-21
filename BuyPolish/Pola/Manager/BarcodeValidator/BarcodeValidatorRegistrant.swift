import Foundation
import Swinject

final class BarcodeValidatorRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(BarcodeValidator.self) { _ in
            EANBarcodeValidator()
        }
    }
}
