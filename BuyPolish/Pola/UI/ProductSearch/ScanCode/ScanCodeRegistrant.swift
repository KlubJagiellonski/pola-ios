import Swinject
import UIKit

final class ScanCodeRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ScanResultViewController.self) { resolver, barcode in
            ScanResultViewController(barcode: barcode,
                                     productManager: resolver.resolve(ProductManager.self)!,
                                     analyticsProvider: resolver.resolve(AnalyticsProvider.self)!)
        }

        container.register(ResultsViewController.self) { resolver in
            ResultsViewController(barcodeValidator: resolver.resolve(BarcodeValidator.self)!, analyticsProvider: resolver.resolve(AnalyticsProvider.self)!)
        }

        container.register(ScanCodeViewController.self) { resolver in
            ScanCodeViewController(flashlightManager: resolver.resolve(FlashlightManager.self)!, analyticsProvider: resolver.resolve(AnalyticsProvider.self)!)
        }
    }
}
