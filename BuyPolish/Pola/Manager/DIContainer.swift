import Swinject

class DI {
    
    static let container: Resolver = {
        let container = Container()
        
        container.register(BPProductImageManager.self) { _ in
            BPProductImageManager()
        }
        
        container.register(BPKeyboardManager.self) { _ in
            BPKeyboardManager()
        }
        
        container.register(BPTaskRunner.self) { _ in
            BPTaskRunner()
        }
        
        container.register(BPAPIAccessor.self) { _ in
            BPAPIAccessor()
        }
        
        container.register(BPReportManager.self) { _ in
            BPReportManager()
        }.initCompleted { (resolver, reportManager) in
            reportManager.taskRunner = resolver.resolve(BPTaskRunner.self)!
            reportManager.apiAccessor = resolver.resolve(BPAPIAccessor.self)!
            
        }
        
        container.register(ReportProblemViewController.self) { resolver, productId, barcode in
            ReportProblemViewController(productId: productId,
                                        barcode: barcode,
                                        productImageManager: resolver.resolve(BPProductImageManager.self)!,
                                        reportManager: resolver.resolve(BPReportManager.self)!,
                                        keyboardManager: resolver.resolve(BPKeyboardManager.self)!)
            
        }
        
        return container
    }()
    
}
