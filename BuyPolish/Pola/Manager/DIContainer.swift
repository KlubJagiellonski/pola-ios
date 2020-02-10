import Swinject

class DI {
    
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
            KeyboardManager(notificationCenter: resolver.resolve(NotificationCenter.self)!)
        }
        
        container.register(FileManager.self) { _ in
            FileManager.default
        }
        
        container.register(CodeScannerManager.self) { _ in
            CameraSessionCodeScannerManager()
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
        
        container.register(MediaUploadRequestFactory.self) { resolver in
            PutAmazonRequestFactory(fileManager: resolver.resolve(FileManager.self)!)
        }
        
        container.register(ReportManager.self) { resolver in
            ReportManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!,
                          uploadMediaRequestFactory: resolver.resolve(MediaUploadRequestFactory.self)!)
        }
        
        container.register(ScannerCodeViewController.self) { resolver in
            ScannerCodeViewController(codeScannerManager: resolver.resolve(CodeScannerManager.self)!)
        }
        
        container.register(ReportProblemViewController.self) { resolver, reason in
            ReportProblemViewController(reason: reason,
                                        productImageManager: resolver.resolve(ProductImageManager.self)!,
                                        reportManager: resolver.resolve(ReportManager.self)!,
                                        keyboardManager: resolver.resolve(KeyboardManager.self)!)
        }
        
        return container
    }()
    
}
