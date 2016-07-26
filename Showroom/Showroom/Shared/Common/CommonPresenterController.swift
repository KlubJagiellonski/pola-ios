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
    
    // MARK:- NavigationHandler

    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let showProductDetailsEvent as ShowProductDetailsEvent:
            if let productDetailsViewController = currentModalViewController as? ProductDetailsViewController {
                retrieveCurrentImageViewTag = nil
                productDetailsViewController.updateData(with: showProductDetailsEvent.context)
            } else {
                let viewController = resolver.resolve(ProductDetailsViewController.self, argument: showProductDetailsEvent.context)
                
                let alternativeAnimation = DimTransitionAnimation(animationDuration: 0.3)
                if let imageViewTag = showProductDetailsEvent.retrieveCurrentImageViewTag?(), let imageView = view.viewWithTag(imageViewTag) as? UIImageView where imageView.image != nil {
                    retrieveCurrentImageViewTag = showProductDetailsEvent.retrieveCurrentImageViewTag
                    let animation = ImageTranstionAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
                    showModal(viewController, hideContentView: false, animation: animation, completion: nil)
                } else {
                    showModal(viewController, hideContentView: true, animation: alternativeAnimation, completion: nil)
                }
            }
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .CloseImmediately:
                hideModal(animation: nil, completion: nil)
                return true
            case .Close:
                let alternativeAnimation = DimTransitionAnimation(animationDuration: 0.4)
                let contentView = contentViewController?.view ?? hiddenContentViewController?.view
                if let tag = retrieveCurrentImageViewTag?(), let imageView = contentView?.viewWithTag(tag) as? UIImageView where imageView.image != nil {
                    let animation = ImageTranstionAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
                    hideModal(animation: animation, completion: nil)
                } else {
                    hideModal(animation: alternativeAnimation, completion: nil)
                }
                retrieveCurrentImageViewTag = nil
                return true
            case .ProductAddedToBasket:
                if let basketFrame = basketTabBarItemFrame {
                    hideModal(animation: GenieTransitionAnimation(animationDuration: 0.3, destinationRect: basketFrame), completion: nil)
                } else {
                    logError("TabBar not exist, something is wrong")
                    hideModal(animation: nil, completion: nil)
                }
                return true
            default: return false
            }
        default: return false
        }
    }
}

extension CommonPresenterController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        guard let deepLinkingHandler = (contentViewController ?? hiddenContentViewController) as? DeepLinkingHandler else {
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