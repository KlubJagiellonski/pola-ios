import Swinject
import UIKit

final class KeyboardViewControllerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(KeyboardViewController.self) { resolver in
            KeyboardViewController(barcodeValidator: resolver.resolve(BarcodeValidator.self)!)
        }
    }
}
