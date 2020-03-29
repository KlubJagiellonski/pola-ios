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
        
        container.register(CaptureVideoManager.self) { _ in
            CameraCaptureVideoManager()
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
            PutAmazonRequestFactory()
        }
        
        container.register(ReportManager.self) { resolver in
            ReportManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!,
                          uploadMediaRequestFactory: resolver.resolve(MediaUploadRequestFactory.self)!,
                          fileManager: resolver.resolve(FileManager.self)!)
        }
        
        container.register(CapturedImagesUploadManager.self) { resolver in
             CapturedImagesUploadManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!,
                                         uploadMediaRequestFactory: resolver.resolve(MediaUploadRequestFactory.self)!)
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
                                        keyboardManager: resolver.resolve(KeyboardManager.self)!)
        }
        
        container.register(CaptureVideoInstructionViewController.self) {  _, scanResult in
                 CaptureVideoInstructionViewController(scanResult: scanResult)
        }
        
        container.register(CaptureVideoViewController.self) {  resolver, scanResult in
            CaptureVideoViewController(scanResult: scanResult,
                                       videoManager: resolver.resolve(CaptureVideoManager.self)!,
                                       imageManager: resolver.resolve(CapturedImageManager.self)!,
                                       uploadManager: resolver.resolve(CapturedImagesUploadManager.self)!,
                                       device: resolver.resolve(UIDevice.self)!)
        }
        
        container.register(ScanResultViewController.self) { resolver, barcode in
            ScanResultViewController(barcode: barcode,
                                     productManager: resolver.resolve(ProductManager.self)!)
        }
        
        container.register(ResultsViewController.self) { resolver in
            ResultsViewController(barcodeValidator: resolver.resolve(BarcodeValidator.self)!)
        }
        
        container.register(ScanCodeViewController.self) { resolver in
            ScanCodeViewController(flashlightManager: resolver.resolve(FlashlightManager.self)!)
        }

        return container
    }()
    
}
