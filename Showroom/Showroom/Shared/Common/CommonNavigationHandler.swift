import Foundation
import UIKit
import JLRoutes

class CommonNavigationHandler: NavigationHandler {
    private weak var navigationController: UINavigationController?
    private let resolver: DiResolver
    private let navigationDelegateHandler: CommonNavigationControllerDelegateHandler
    private let urlRouter = JLRoutes()
    
    init(hideNavigationBarForFirstView: Bool, with navigationController: UINavigationController, and resolver: DiResolver) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.navigationDelegateHandler = CommonNavigationControllerDelegateHandler(hideNavigationBarForFirstView: hideNavigationBarForFirstView)
        
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
        case let brandProductListEvent as ShowBrandProductListEvent:
            showBrandProductList(productBrand: brandProductListEvent.productBrand)
            return true
        default:
            return false
        }
    }
    
    private func showView(forURL url: NSURL, title: String?) -> Bool {
        let parameters: [NSObject: AnyObject] = title == nil ? [:]: ["title": title!]
        return urlRouter.routeURL(url, withParameters: parameters)
    }
    
    private func showBrandDescription(brand: Brand) {
        let viewController = resolver.resolve(BrandDescriptionViewController.self, argument: brand)
        configureChildViewController(viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSearchProductList(query query: String) {
        let viewController = resolver.resolve(SearchProductListViewController.self, argument: EntrySearchInfo(query: query))
        configureChildViewController(viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showBrandProductList(productBrand productBrand: EntryProductBrand) {
        guard let navigationController = navigationController else { return }
        
        if let brandProductListViewController = navigationController.visibleViewController as? BrandProductListViewController {
            brandProductListViewController.updateData(with: productBrand)
        } else {
            let viewController = resolver.resolve(BrandProductListViewController.self, argument: productBrand)
            configureChildViewController(viewController)
            navigationController.pushViewController(viewController, animated: true)
        }
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
        urlRouter.addRoute("/:host/tag/*") { [weak self](parameters: [NSObject: AnyObject]) in
            guard let `self` = self else { return false }
            guard let url = parameters[kJLRouteURLKey] as? NSURL else {
                logError("Cannot retrieve routeURLKey for \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let entryCategory = EntryCategory(link: url.absoluteString, name: title)
            return self.handleRouting(forProductListViewControllerType: CategoryProductListViewController.self, entryData: entryCategory)
        }
        urlRouter.addRoute("/:host/marki/:brandComponent") { [weak self](parameters: [NSObject: AnyObject]!) in
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
            
            let entryProductBrand = EntryProductBrand(id: brandId, name: title)
            return self.handleRouting(forProductListViewControllerType: BrandProductListViewController.self, entryData: entryProductBrand)
        }
        urlRouter.addRoute("/:host/trend/:trendSlug") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let trendSlug = parameters["trendSlug"] as? String else {
                logError("There is no trendSlug in path: \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let entryTrendInfo = EntryTrendInfo(slug: trendSlug, name: title)
            return self.handleRouting(forProductListViewControllerType: TrendProductListViewController.self, entryData: entryTrendInfo)
        }
        urlRouter.addRoute("/:host/search") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let query = parameters["s"] as? String else {
                logError("There is no query parameter in path: \(parameters)")
                return false
            }
            let entrySearchInfo = EntrySearchInfo(query: query)
            return self.handleRouting(forProductListViewControllerType: SearchProductListViewController.self, entryData: entrySearchInfo)
        }
        urlRouter.addRoute("/:host/p/:productComponent") { [weak self](parameters: [NSObject: AnyObject]!) in
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
    
    /*
    * The idea is simple:
    * - if there is existing view controller with that type in stack we are popping to it with no animtion and changing content
    * - if not, we are creating new view controller and pushing it to navigation stack
    */
    private func handleRouting<T: UIViewController where T:ProductListViewControllerInterface>(forProductListViewControllerType viewControllerType: T.Type, entryData: T.EntryData) -> Bool {
        guard let navigationController = self.navigationController else { return false }
        navigationController.sendNavigationEvent(SimpleNavigationEvent(type: .CloseImmediately))
        
        
        navigationController.forceCloseModal()
        for viewController in navigationController.viewControllers {
            viewController.forceCloseModal()
        }
        if let viewController = navigationController.viewControllers.find({ $0 is T }) as? T {
            navigationController.popToViewController(viewController, animated: false)
            viewController.updateData(with: entryData)
        } else {
            let viewController = self.resolver.resolve(viewControllerType, argument: entryData)
            self.configureChildViewController(viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        return true
    }
}

extension CommonNavigationHandler: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        return showView(forURL: url, title: nil)
    }
}

class CommonNavigationControllerDelegateHandler: NSObject, UINavigationControllerDelegate {
    private let hideNavigationBarForFirstView: Bool
    
    init(hideNavigationBarForFirstView: Bool) {
        self.hideNavigationBarForFirstView = hideNavigationBarForFirstView
        super.init()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        guard hideNavigationBarForFirstView else { return }
        if viewController == navigationController.viewControllers.first && !navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else if viewController != navigationController.viewControllers.first && navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
}