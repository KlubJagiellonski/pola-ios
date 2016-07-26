import Foundation
import UIKit

final class SearchNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private lazy var commonNavigationHandler: CommonNavigationHandler = { [unowned self] in
        return CommonNavigationHandler(hideNavigationBarForFirstView: true, with: self, and: self.resolver)
        }()
    
    init(with resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        setNavigationBarHidden(true, animated: false)
        
        let viewController = resolver.resolve(SearchViewController.self)
        viewController.resetBackTitle()
        viewControllers = [viewController]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        return commonNavigationHandler.handleNavigationEvent(event)
    }
}

extension SearchNavigationController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        return commonNavigationHandler.handleOpen(withURL: url)
    }
}

extension SearchNavigationController: MainTabChild {
    func popToFirstView() {
        popToRootViewControllerAnimated(true)
    }
}