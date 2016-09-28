import Foundation
import UIKit
import RxSwift

final class PromoSlideshowViewController: UIViewController, PromoSlideshowViewDelegate, PromoPageDelegate {
    private let model: PromoSlideshowModel
    private var castView: PromoSlideshowView { return view as! PromoSlideshowView }
    private var indexedViewControllers: [Int: UIViewController] = [:]
    
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver, slideshowId: Int) {
        self.resolver = resolver
        self.model = resolver.resolve(PromoSlideshowModel.self, argument: slideshowId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PromoSlideshowView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.pageHandler = self
        
        fetchSlideshow()
    }
    
    func updateData(with slideshowId: Int) {
        // TODO: updating data
    }
    
    private func fetchSlideshow() {
        logInfo("Fetching slideshow")
        model.fetchPromoSlideshow().subscribe { [weak self] (event: Event<PromoSlideshow>) in
            guard let `self` = self else { return }
            
            switch event {
            case .Next(let result):
                logInfo("Fetched slideshow \(result)")
                self.castView.changeSwitcherState(.Success, animated: true)
                self.castView.update(with: result)
            case .Error(let error):
                logInfo("Cannot fetch slideshow \(error)")
                self.castView.changeSwitcherState(.Error, animated: true)
            case .Completed: break
            }
        }.addDisposableTo(disposeBag)
    }
    
    // MARK:- PromoSlideshowViewDelegate
    
    func promoSlideshowDidTapClose(promoSlideshow: PromoSlideshowView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .Close))
    }
    
    // MARK:- ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        castView.changeSwitcherState(.Loading, animated: true)
        fetchSlideshow()
    }
    
    // MARK:- PromoStepDelegate
    
    func promoPageDidDownloadAllData(promoPage: PromoPageInterface) {
        model.prefetchData(forPageAtIndex: castView.currentPageIndex + 1)
    }
    
    func promoPage(promoPage: PromoPageInterface, didChangeCurrentProgress currentProgress: Double) {
        let progressState = ProgressInfoState(currentStep: castView.currentPageIndex, currentStepProgress: currentProgress)
        castView.update(with: progressState)
    }
    
    func promoPage(promoStep: PromoPageInterface, willChangePromoPageViewState newViewState: PromoPageViewState, animationDuration: Double?) {
        castView.update(with: newViewState, animationDuration: animationDuration)
    }
    
    func promoPageDidFinished(promoStep: PromoPageInterface) {
        castView.moveToNextPage()
    }
}

extension PromoSlideshowViewController: PromoSlideshowPageHandler {
    func page(forIndex index: Int, removePageIndex: Int?) -> UIView {
        logInfo("Creating page for index \(index), removePageIndex \(removePageIndex)")
        guard let data = model.data(forPageIndex: index) else {
            logInfo("Could not retrieve data")
            return UIView()
        }
        let currentViewController = removePageIndex == nil ? nil : indexedViewControllers[removePageIndex!]
        let newViewController = createViewController(from: data)
        
        guard let promoPageInterface = newViewController as? PromoPageInterface else {
            fatalError("View controller \(newViewController) must implement protocol PromoPageInterface")
        }
        promoPageInterface.delegate = self
        
        currentViewController?.willMoveToParentViewController(nil)
        addChildViewController(newViewController)
        return newViewController.view
    }
    
    func pageAdded(forIndex index: Int, removePageIndex: Int?) {
        logInfo("Page added for index \(index), removePageIndex \(removePageIndex)")
        let currentViewController = removePageIndex == nil ? nil : indexedViewControllers[removePageIndex!]
        let newViewController = childViewControllers.last!
        
        currentViewController?.removeFromParentViewController()
        newViewController.didMoveToParentViewController(self)
        
        if removePageIndex != nil {
            indexedViewControllers[removePageIndex!] = nil
        }
        indexedViewControllers[index] = newViewController
        logInfo("Indexed view controllers \(indexedViewControllers)")
    }
    
    private func removeAllViewControllers() {
        logInfo("Remove all view controllers \(indexedViewControllers)")
        indexedViewControllers.forEach { (index, viewController) in
            viewController.forceCloseModal()
            viewController.willMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        indexedViewControllers.removeAll()
    }
    
    //perfectly parent should set content inset, but it would be too much work and too much complications
    private func createChildViewContentInset() -> UIEdgeInsets {
        let bottomInset = bottomLayoutGuide.length == 0 ? Dimensions.tabViewHeight : bottomLayoutGuide.length
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    private func createViewController(from data: PromoSlideshowPageData) -> UIViewController {
        switch data {
        case .Image(let link):
            return resolver.resolve(ImageStepViewController.self, argument: link)
        case .Video(let link):
            return resolver.resolve(VideoStepViewController.self, argument: link)
        case .Product(let productId):
            return resolver.resolve(ProductStepViewController.self, argument: productId)
        case .Summary(let promoSlideshow):
            return resolver.resolve(PromoSummaryViewController.self, argument: promoSlideshow)
        }
    }
 
}