import Foundation
import UIKit

class CommonNavigationHandler: NavigationHandler {
    private weak var navigationController: UINavigationController?
    private let resolver: DiResolver
    
    init(with navigationController: UINavigationController, and resolver: DiResolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let linkEvent as ShowItemForLinkEvent:
            showView(forLink: linkEvent.link)
            return true
        case let brandDescriptionEvent as ShowBrandDescriptionEvent:
            showBrandDescription(brandDescriptionEvent.brand)
            return true
        default:
            return false
        }
    }

    private func showView(forLink link: String) {
        // todo deeplink handling
        navigationController?.setNavigationBarHidden(false, animated: true)
        
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
    
    private func configureChildViewController(viewController: UIViewController) {
        if let extendedViewController = viewController as? ExtendedViewController {
            let topLayoutGuide = navigationController?.topLayoutGuide.length ?? 0
            let bottomLayoutGuide = navigationController?.bottomLayoutGuide.length ?? 0
            let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
            extendedViewController.extendedContentInset = UIEdgeInsetsMake(topLayoutGuide + navigationBarHeight, 0, bottomLayoutGuide, 0)
        }
        viewController.applyBlackBackButton(target: self, action: #selector(CommonNavigationHandler.didTapBackButton))
    }
    
    @objc func didTapBackButton() {
        guard let navigationController = navigationController else { return }
        // this is correct only when first vc have navigationbar and all next vcs doesn't have. If this will change we should make some nicer approach
        if navigationController.viewControllers.count == 2 {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
        navigationController.popViewControllerAnimated(true)
    }
}