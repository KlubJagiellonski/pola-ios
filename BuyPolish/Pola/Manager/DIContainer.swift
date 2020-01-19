import Swinject

class DI {
    
    static let container: Resolver = {
        let container = Container()
                
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
        
        container.register(FileManager.self) { _ in
            FileManager.default
        }
        
        container.register(ProductImageManager.self) { resolver in
            LocalDocumentsProductImageManager(fileManager: resolver.resolve(FileManager.self)!)
        }
        
        container.register(ReportProblemViewController.self) { resolver, reason in
            ReportProblemViewController(reason: reason,
                                        productImageManager: resolver.resolve(ProductImageManager.self)!,
                                        reportManager: resolver.resolve(BPReportManager.self)!,
                                        keyboardManager: resolver.resolve(BPKeyboardManager.self)!)
            
        }
        
        return container
    }()
    
}
