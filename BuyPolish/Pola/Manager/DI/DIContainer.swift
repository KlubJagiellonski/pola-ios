import Swinject

final class DI {
    static let container: Resolver = {
        let container = Container()

        let registrants: [DependencyRegistrant] = [
            AnalyticsRegistrant(),
            BarcodeValidatorRegistrant(),
            CapturedImageManagerRegistrant(),
            CodeScannerManagerRegistrant(),
            FlashlightManagerRegistrant(),
            FoundationRegistrant(),
            KeyboardManagerRegistrant(),
            KeyboardViewControllerRegistrant(),
            LoggerRegistrant(),
            ProductImageManagerRegistrant(),
            ProductManagerRegistrant(),
            ReportManagerRegistrant(),
            ReportProblemViewControllerRegistrant(),
            RequestFactoryRegistrant(),
            ScanCodeRegistrant(),
            UIKitRegistrant(),
        ]
        registrants.forEach { $0.registerDependency(container: container) }
        return container
    }()
}
