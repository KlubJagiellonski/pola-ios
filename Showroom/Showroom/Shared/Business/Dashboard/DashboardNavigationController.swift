import Foundation
import UIKit

class DashboardNavigationController: UINavigationController {
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        setNavigationBarHidden(true, animated: false)
        
        let viewController = resolver.resolve(DashboardViewController.self)
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
