import Foundation
import UIKit

class CommonPresenterController: PresenterViewController, NavigationHandler {
    
    private let resolver: DiResolver
    private var retrieveCurrentImageViewTag: (() -> Int?)?
    private var basketTabBarItemFrame: CGRect? {
        guard let tabBarController = tabBarController else { return nil }
        let tabBarFrame = tabBarController.tabBar.frame
        let size = CGSizeMake(180, 22)
        return CGRectMake(tabBarFrame.midX - size.width / 2, tabBarFrame.midY - size.height / 2, size.width, size.height)
    }
    
    init(with resolver: DiResolver, contentViewController: UIViewController) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        showContent(contentViewController, animation: nil, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func closeModal(withCompletion completion: ((Bool) -> ())?) {
        guard currentModalViewController != nil else {
            retrieveCurrentImageViewTag = nil
            completion?(true)
            return
        }
        let alternativeAnimation = DimTransitionAnimation(animationDuration: 0.4)
        let contentView = contentViewController?.view
        if let tag = retrieveCurrentImageViewTag?(), let imageView = contentView?.viewWithTag(tag) as? UIImageView where imageView.image != nil {
            let animation = ImageTransitionAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
            hideModal(animation: animation, completion: completion)
        } else {
            hideModal(animation: alternativeAnimation, completion: completion)
        }
        retrieveCurrentImageViewTag = nil
    }
    
    private func showProductDetails(with event: ShowProductDetailsEvent) {
        if let productDetailsViewController = currentModalViewController as? ProductDetailsViewController {
            retrieveCurrentImageViewTag = nil
            productDetailsViewController.updateData(with: event.context)
            return
        }
        
        closeModal() { [weak self] _ in
            guard let `self` = self else { return }
            
            let viewController = self.resolver.resolve(ProductDetailsViewController.self, argument: event.context)
            
            let alternativeAnimation = DimTransitionAnimation(animationDuration: 0.3)
            if let imageViewTag = event.retrieveCurrentImageViewTag?(),
                let imageView = self.view.viewWithTag(imageViewTag) as? UIImageView
            where imageView.image != nil {
                self.retrieveCurrentImageViewTag = event.retrieveCurrentImageViewTag
                let animation = ImageTransitionAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
                self.showModal(viewController, hideContentView: false, animation: animation, completion: nil)
            } else {
                self.showModal(viewController, hideContentView: true, animation: alternativeAnimation, completion: nil)
            }
        }
        
    }
    
    private func showPromoSlideshow(with event: ShowPromoSlideshowEvent) {
        if let promoSlideshowViewController = currentModalViewController as? PromoSlideshowViewController {
            promoSlideshowViewController.updateData(withSlideshowId: event.slideshowId)
            return
        }
        closeModal() { [weak self] _ in
            guard let `self` = self else { return }
            
            let viewController = self.resolver.resolve(PromoSlideshowViewController.self, argument: event.slideshowId)
            let animation = DimTransitionAnimation(animationDuration: 0.3)
            self.showModal(viewController, hideContentView: true, animation: animation, completion: nil)
        }
    }
    
    private func closeModalAndPropagateToContent(with event: NavigationEvent) {
        closeModal() { [weak self] _ in
            guard let `self` = self else { return }
            
            var eventHandled = false
            if let navigationHandler = self.contentViewController as? NavigationHandler {
                eventHandled = navigationHandler.handleNavigationEvent(event)
            }
            if !eventHandled {
                logError("Couldn not handle event \(self.contentViewController) \(event)")
            }
        }
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        logInfo("Handling navigation event \(event.dynamicType)")
        switch event {
        case let showProductDetailsEvent as ShowProductDetailsEvent:
            showProductDetails(with: showProductDetailsEvent)
            return true
        case let brandProductListEvent as ShowBrandProductListEvent:
            closeModalAndPropagateToContent(with: brandProductListEvent)
            return true
        case let showItemForLinkEvent as ShowItemForLinkEvent:
            closeModalAndPropagateToContent(with: showItemForLinkEvent)
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .CloseImmediately:
                currentModalViewController?.forceCloseModal()
                hideModal(animation: nil, completion: nil)
                retrieveCurrentImageViewTag = nil
                return true
            case .Close:
                closeModal(withCompletion: nil)
                return true
            case .ProductAddedToBasket:
                if let basketFrame = basketTabBarItemFrame {
                    hideModal(animation: GenieTransitionAnimation(animationDuration: 0.3, destinationRect: basketFrame), completion: nil)
                } else {
                    logError("TabBar not exist, something is wrong")
                    hideModal(animation: nil, completion: nil)
                }
                retrieveCurrentImageViewTag = nil
                return true
            default: return false
            }
        case let promoSlideshowEvent as ShowPromoSlideshowEvent:
            showPromoSlideshow(with: promoSlideshowEvent)
            return true
        default: return false
        }
    }
}

extension CommonPresenterController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        logInfo("Opening URL: \(url)")
        guard let deepLinkingHandler = contentViewController as? DeepLinkingHandler else {
            return false
        }
        return deepLinkingHandler.handleOpen(withURL: url)
    }
}

extension CommonPresenterController: MainTabChild {
    func popToFirstView() {
        hideModal(animation: DimTransitionAnimation(animationDuration: 0.2)) { [weak self] _ in
            if let childContent = self?.contentViewController as? MainTabChild {
                childContent.popToFirstView()
            }
        }
    }
}