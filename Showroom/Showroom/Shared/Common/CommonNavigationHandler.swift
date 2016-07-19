import Foundation
import UIKit

class CommonNavigationHandler: NavigationHandler {
    private weak var navigationController: UINavigationController?
    private let resolver: DiResolver
    private let navigationDelegateHandler = CommonNavigationControllerDelegateHandler()
    
    init(with navigationController: UINavigationController, and resolver: DiResolver) {
        self.navigationController = navigationController
        self.resolver = resolver
        
        navigationController.delegate = navigationDelegateHandler
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let linkEvent as ShowItemForLinkEvent:
            showView(forLink: linkEvent.link, title: linkEvent.title)
            return true
        case let brandDescriptionEvent as ShowBrandDescriptionEvent:
            showBrandDescription(brandDescriptionEvent.brand)
            return true
        case let searchEvent as ShowProductSearchEvent:
            showSearchProductList(query: searchEvent.query)
            return true
        default:
            return false
        }
    }

    private func showView(forLink link: String, title: String?) {
        logInfo("Opening link in dashboard \(link)")
        
        //todo remove when we will have deep linking
        if link == "https://www.showroom.pl/marki/1027" {
            let viewController = resolver.resolve(TrendProductListViewController.self)
            configureChildViewController(viewController)
            navigationController?.pushViewController(viewController, animated: true)
        } else if link == "https://www.showroom.pl/marki/3141" {
            let viewController = resolver.resolve(BrandProductListViewController.self, argument: ProductBrand(id: 1, name: "RISK Made in Warsaw"))
            configureChildViewController(viewController)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = resolver.resolve(CategoryProductListViewController.self, argument: Category(id: 1, name: "Sukienki i tuniki"))
            configureChildViewController(viewController)
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    private func showBrandDescription(brand: Brand) {
        let viewController = resolver.resolve(BrandDescriptionViewController.self, argument: brand)
        configureChildViewController(viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSearchProductList(query query: String) {
        let viewController = resolver.resolve(SearchProductListViewController.self, argument: query)
        configureChildViewController(viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configureChildViewController(viewController: UIViewController) {
        if let extendedViewController = viewController as? ExtendedViewController {
            let topLayoutGuide = navigationController?.topLayoutGuide.length ?? 0
            let bottomLayoutGuide = navigationController?.bottomLayoutGuide.length ?? 0
            let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
            extendedViewController.extendedContentInset = UIEdgeInsetsMake(topLayoutGuide + navigationBarHeight, 0, bottomLayoutGuide, 0)
        }
        viewController.resetBackTitle()
    }
}

class CommonNavigationControllerDelegateHandler: NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first && !navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else if viewController != navigationController.viewControllers.first && navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
}