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
        
        container.register(BPReportProblemViewController.self) { (_) in
            BPReportProblemViewController()
        }.initCompleted { (resolver, viewController) in
            viewController.productImageManager = resolver.resolve(BPProductImageManager.self)!
            viewController.reportManager = resolver.resolve(BPReportManager.self)!
            viewController.keyboardManager = resolver.resolve(BPKeyboardManager.self)!
        }
        return container
    }()
    
}
