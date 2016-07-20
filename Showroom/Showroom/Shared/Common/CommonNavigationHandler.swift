import Foundation
import UIKit
import JLRoutes

class CommonNavigationHandler: NavigationHandler {
    private weak var navigationController: UINavigationController?
    private let resolver: DiResolver
    private let navigationDelegateHandler = CommonNavigationControllerDelegateHandler()
    private let urlRouter = JLRoutes()
    
    init(with navigationController: UINavigationController, and resolver: DiResolver) {
        self.navigationController = navigationController
        self.resolver = resolver
        
        navigationController.delegate = navigationDelegateHandler
        
        configureRouter()
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let linkEvent as ShowItemForLinkEvent:
            if let url = NSURL(string: linkEvent.link) {
                showView(forURL: url, title: linkEvent.title)
            } else {
                logError("Cannot create NSURL from \(linkEvent.link)")
            }
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

    private func showView(forURL url: NSURL, title: String?) -> Bool {
        let parameters: [NSObject: AnyObject] = title == nil ? [:] : ["title": title!]
        //todo remove it when we will have trend in content promo
        if url.absoluteString == "https://www.showroom.pl/marki/1027" {
            return urlRouter.routeURL(NSURL(string: "https://www.showroom.pl/trend/stylowekreacjenawesele"), withParameters: parameters)
        } else {
            return urlRouter.routeURL(url, withParameters: parameters)
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
    
    private func configureRouter() {
        urlRouter.addRoute("/:host/tag/*") { [weak self] (parameters: [NSObject: AnyObject]) in
            guard let `self` = self else { return false }
            guard let url = parameters[kJLRouteURLKey] as? NSURL else {
                logError("Cannot retrieve routeURLKey for \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let viewController = self.resolver.resolve(CategoryProductListViewController.self, argument: EntryCategory(link: url.absoluteString, name: title))
            self.configureChildViewController(viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
            
            return true
        }
        urlRouter.addRoute("/:host/marki/:brandComponent") { [weak self] (parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let brandComponent = parameters["brandComponent"] as? String else {
                logError("There is no brandComponent in path: \(parameters)")
                return false
            }
            let brandComponents = brandComponent.componentsSeparatedByString(",")
            guard let brandId = Int(brandComponents[0]) else {
                logError("Cannot retrieve brandId for path: \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let viewController = self.resolver.resolve(BrandProductListViewController.self, argument: EntryProductBrand(id: brandId, name: title))
            self.configureChildViewController(viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
            
            return true
        }
        urlRouter.addRoute("/:host/trend/:trendSlug") { [weak self] (parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let trendSlug = parameters["trendSlug"] as? String else {
                logError("There is no trendSlug in path: \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let viewController = self.resolver.resolve(TrendProductListViewController.self, argument: EntryTrendInfo(slug: trendSlug, name: title))
            self.configureChildViewController(viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
        
            return true
        }
        urlRouter.addRoute("/:host/p/:productComponent") { [weak self] (parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let productComponent = parameters["productComponent"] as? String else {
                logError("There is no productComponent in path: \(parameters)")
                return false
            }
            let productComponents = productComponent.componentsSeparatedByString(",")
            guard let productId = Int(productComponents[0]) else {
                logError("Cannot retrieve productId for path: \(parameters)")
                return false
            }
            
            let context = OneProductDetailsContext(productInfo: ProductInfo.Id(productId))
            self.navigationController?.sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: nil))
            
            return true
        }
        urlRouter.unmatchedURLHandler = { (routes: JLRoutes, url: NSURL?, parameters: [NSObject: AnyObject]?) in
            logError("Cannot match url: \(url), parameters \(parameters)")
        }
    }
}

extension CommonNavigationHandler: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        return showView(forURL: url, title: nil)
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