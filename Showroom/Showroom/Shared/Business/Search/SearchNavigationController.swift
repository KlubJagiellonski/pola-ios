import Foundation
import UIKit

final class SearchNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    
    init(with resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        setNavigationBarHidden(true, animated: false)
        
        let viewController = resolver.resolve(SearchViewController.self)
        viewControllers = [viewController]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        return false
    }
}
