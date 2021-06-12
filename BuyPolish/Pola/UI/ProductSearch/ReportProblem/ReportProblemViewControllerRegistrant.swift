import Swinject
import UIKit

final class ReportProblemViewControllerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ReportProblemViewController.self) { resolver, reason in
            ReportProblemViewController(reason: reason,
                                        productImageManager: resolver.resolve(ProductImageManager.self)!,
                                        reportManager: resolver.resolve(ReportManager.self)!,
                                        keyboardManager: resolver.resolve(KeyboardManager.self)!,
                                        analyticsProvider: resolver.resolve(AnalyticsProvider.self)!)
        }
    }
}
