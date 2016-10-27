import Foundation
import UIKit
import JLRoutes

final class CommonNavigationHandler: NavigationHandler {
    private weak var navigationController: UINavigationController?
    private let resolver: DiResolver
    private let configurationManager: ConfigurationManager
    private let navigationDelegateHandler: CommonNavigationControllerDelegateHandler
    private let urlRouter = JLRoutes()
    
    init(hideNavigationBarForFirstView: Bool, with navigationController: UINavigationController, and resolver: DiResolver) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.navigationDelegateHandler = CommonNavigationControllerDelegateHandler(hideNavigationBarForFirstView: hideNavigationBarForFirstView)
        self.configurationManager = resolver.resolve(ConfigurationManager.self)
        
        navigationController.delegate = navigationDelegateHandler
        
        configureRouter()
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        logInfo("Handling navigation event \(event.dynamicType)")
        switch event {
        case let linkEvent as ShowItemForLinkEvent:
            if let url = NSURL(string: linkEvent.link) {
                let fromType = linkEvent.productDetailsFromType
                let additionalParams: [NSObject: AnyObject] = fromType == nil ? [:] : ["fromType": fromType!.rawValue]
                showView(forURL: url, title: linkEvent.title, additionalParams: additionalParams, transitionImageTag: linkEvent.transitionImageTag)
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
    
    private func showView(forURL url: NSURL, title: String?, additionalParams: [NSObject: AnyObject] = [:], transitionImageTag: Int? = nil) -> Bool {
        logInfo("Showing view for URL: \(url.absoluteString)")
        var params = additionalParams
        if let title = title {
            params["title"] = title
        }
        if let transitionImageTag = transitionImageTag {
            params["transitionImageTag"] = transitionImageTag
        }
        return urlRouter.routeURL(url, withParameters: params)
    }
    
    private func showBrandDescription(brand: BrandDetails) {
        let viewController = resolver.resolve(BrandDescriptionViewController.self, argument: brand)
        configureChildViewController(viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSearchProductList(query query: String) {
        let viewController = resolver.resolve(SearchProductListViewController.self, argument: EntrySearchInfo(query: query, link: nil))
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
        viewController.resetBackTitle()
    }
    
    private func configureRouter() {
        urlRouter.addRoute("/:host/tag/*") { [weak self](parameters: [NSObject: AnyObject]) in
            guard let `self` = self else { return false }
            guard let url = parameters[kJLRouteURLKey] as? NSURL, let urlString = url.absoluteString else {
                logError("Cannot retrieve routeURLKey for \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let entryCategory = EntryCategory(link: urlString, name: title)
            return self.handleRoutingForProductList(forProductListViewControllerType: CategoryProductListViewController.self, entryData: entryCategory)
        }
        
        if let brandsPathComponent = configurationManager.configuration?.deepLinkConfiguration.brandPathComponent {
            urlRouter.addRoute("/:host/\(brandsPathComponent)/:brandComponent") { [weak self](parameters: [NSObject: AnyObject]!) in
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
                let url = parameters[kJLRouteURLKey] as? NSURL
                
                let entryProductBrand = EntryProductBrand(id: brandId, name: title, link: url?.absoluteString)
                return self.handleRoutingForProductList(forProductListViewControllerType: BrandProductListViewController.self, entryData: entryProductBrand)
            }
        } else {
            logError("Cannot create router for brand. No configuration.")
        }
        
        urlRouter.addRoute("/:host/trend/:trendSlug") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let trendSlug = parameters["trendSlug"] as? String else {
                logError("There is no trendSlug in path: \(parameters)")
                return false
            }
            let title = parameters["title"] as? String
            
            let entryTrendInfo = EntryTrendInfo(slug: trendSlug, name: title)
            return self.handleRoutingForProductList(forProductListViewControllerType: TrendProductListViewController.self, entryData: entryTrendInfo)
        }
        urlRouter.addRoute("/:host/search") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let query = parameters["s"] as? String else {
                logError("There is no query parameter in path: \(parameters)")
                return false
            }
            let url = parameters[kJLRouteURLKey] as? NSURL
            
            let entrySearchInfo = EntrySearchInfo(query: query, link: url?.absoluteString)
            return self.handleRoutingForProductList(forProductListViewControllerType: SearchProductListViewController.self, entryData: entrySearchInfo)
        }
        urlRouter.addRoute("/:host/p/*") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let wildcardComponents = parameters[kJLRouteWildcardComponentsKey] as? [String], let productComponent = wildcardComponents.first else {
                logError("There is no productComponent in path: \(parameters)")
                return false
            }
            let productComponents = productComponent.componentsSeparatedByString(",")
            guard let productId = Int(productComponents[0]) else {
                logError("Cannot retrieve productId for path: \(parameters)")
                return false
            }
            
            let fromTypeParam = ProductDetailsFromType(rawValue: (parameters["fromType"] as? String) ?? "")
            let fromType = fromTypeParam ?? .DeepLink
            
            let context = OneProductDetailsContext(productInfo: ProductInfo.Id(productId), fromType: fromType)
            self.navigationController?.sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: nil))
            
            return true
        }
        
        urlRouter.addRoute("/:host/videos/:videoComponent") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            guard let videoComponent = parameters["videoComponent"] as? String else {
                logError("There is no videoComponent in path: \(parameters)")
                return false
            }
            let videoComponents = videoComponent.componentsSeparatedByString(",")
            guard let videoId = Int(videoComponents[0]) else {
                logError("Cannot retrieve videoId for path: \(parameters)")
                return false
            }
            let transitionImageTag = parameters["transitionImageTag"] as? Int
            self.navigationController?.sendNavigationEvent(ShowPromoSlideshowEvent(slideshowId: videoId, transitionImageTag: transitionImageTag))
            
            return true
        }
        
        urlRouter.addRoute("/:host/d/:webViewSlug") { [weak self](parameters: [NSObject: AnyObject]!) in
            guard let `self` = self else { return false }
            
            guard let webViewSlug = parameters["webViewSlug"] as? String else {
                logError("There is no webViewSlug in path: \(parameters)")
                return false
            }
            
            return self.handleRouting({ Void -> WebContentViewController in
                return self.resolver.resolve(WebContentViewController.self, argument: webViewSlug)
            }) { (viewController: WebContentViewController) in
                viewController.updateData(withWebViewId: webViewSlug)
            }
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
    
    private func handleRoutingForProductList<T: UIViewController where T:ProductListViewControllerInterface>(forProductListViewControllerType viewControllerType: T.Type, entryData: T.EntryData) -> Bool {
        return handleRouting({ Void -> T in
            return resolver.resolve(viewControllerType, argument: entryData)
        }) { (viewController: T) in
            viewController.updateData(with: entryData)
        }
    }
    
    private func handleRouting<T: UIViewController>(@noescape createHandler: Void -> T, @noescape updateHandler: T -> Void) -> Bool {
        guard let navigationController = self.navigationController else { return false }
        navigationController.sendNavigationEvent(SimpleNavigationEvent(type: .CloseImmediately))
        
        
        navigationController.forceCloseModal()
        for viewController in navigationController.viewControllers {
            viewController.forceCloseModal()
        }
        if let viewController = navigationController.viewControllers.find({ $0 is T }) as? T {
            navigationController.popToViewController(viewController, animated: false)
            updateHandler(viewController)
        } else {
            let viewController = createHandler()
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
