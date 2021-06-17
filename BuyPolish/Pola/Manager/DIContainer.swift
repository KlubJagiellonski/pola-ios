import Swinject

final class DI {

    static let container: Resolver = {
        let container = Container()

        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }

        container.register(ProcessInfo.self) { _ in
            ProcessInfo.processInfo
        }

        container.register(UIDevice.self) { _ in
            UIDevice.current
        }

        container.register(KeyboardManager.self) { resolver in
            NotificationCenterKeyboardManager(notificationCenter: resolver.resolve(NotificationCenter.self)!)
        }

        container.register(FileManager.self) { _ in
            FileManager.default
        }

        container.register(CapturedImageManager.self) { _ in
            InMemoryCapturedImageManager()
        }

        container.register(CodeScannerManager.self) { _ in
            CameraSessionCodeScannerManager()
        }

        container.register(BarcodeValidator.self) { _ in
            EANBarcodeValidator()
        }

        container.register(FlashlightManager.self) { _ in
            FlashlightManager()
        }

        container.register(AnalyticsProvider.self) { _ in
            FirebaseAnalyticsProvider()
        }

        container.register(ProductManager.self) { resolver in
            ProductManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!)
        }

        container.register(ProductImageManager.self) { resolver in
            LocalDocumentsProductImageManager(fileManager: resolver.resolve(FileManager.self)!)
        }

        container.register(DataRequestFactory.self) { resolver in
            PolaRequestFactory(processInfo: resolver.resolve(ProcessInfo.self)!,
                               device: resolver.resolve(UIDevice.self)!)
        }

        container.register(MediaUploadRequestFactory.self) { _ in
            PutAmazonRequestFactory()
        }

        container.register(ReportManager.self) { resolver in
            PolaReportManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!,
                          uploadMediaRequestFactory: resolver.resolve(MediaUploadRequestFactory.self)!,
                          fileManager: resolver.resolve(FileManager.self)!)
        }

        container.register(ScannerCodeViewController.self) { resolver in
            ScannerCodeViewController(codeScannerManager: resolver.resolve(CodeScannerManager.self)!)
        }

        container.register(KeyboardViewController.self) { resolver in
            KeyboardViewController(barcodeValidator: resolver.resolve(BarcodeValidator.self)!)
        }

        container.register(ReportProblemViewController.self) { resolver, reason in
            ReportProblemViewController(reason: reason,
                                        productImageManager: resolver.resolve(ProductImageManager.self)!,
                                        reportManager: resolver.resolve(ReportManager.self)!,
                                        keyboardManager: resolver.resolve(KeyboardManager.self)!,
                                        analyticsProvider: resolver.resolve(AnalyticsProvider.self)!)
        }

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

        return container
    }()

}
