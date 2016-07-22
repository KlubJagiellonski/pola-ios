import Foundation
import UIKit

class CommonPresenterController: PresenterViewController, NavigationHandler {
    
    private let resolver: DiResolver
    private var retrieveCurrentImageViewTag: (() -> Int?)?
    
    init(with resolver: DiResolver, contentViewController: UIViewController) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        self.contentViewController = contentViewController
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
                
                let alternativeAnimation = DimModalAnimation(animationDuration: 0.3)
                if let imageViewTag = showProductDetailsEvent.retrieveCurrentImageViewTag?(), let imageView = view.viewWithTag(imageViewTag) as? UIImageView where imageView.image != nil {
                    retrieveCurrentImageViewTag = showProductDetailsEvent.retrieveCurrentImageViewTag
                    let animation = ImageAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
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
                let alternativeAnimation = DimModalAnimation(animationDuration: 0.3)
                let contentView = contentViewController?.view ?? hiddenContentViewController?.view
                if let tag = retrieveCurrentImageViewTag?(), let imageView = contentView?.viewWithTag(tag) as? UIImageView where imageView.image != nil {
                    let animation = ImageAnimation(animationDuration: 0.4, imageView: imageView, alternativeAnimation: alternativeAnimation)
                    hideModal(animation: animation, completion: nil)
                } else {
                    hideModal(animation: alternativeAnimation, completion: nil)
                }
                retrieveCurrentImageViewTag = nil
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
        hideModal(animation: DimModalAnimation(animationDuration: 0.2)) { [weak self] _ in
            if let childContent = self?.contentViewController as? MainTabChild {
                childContent.popToFirstView()
            }
        }
    }
}