import Foundation
import UIKit
import SnapKit
import RxSwift

class WishlistViewController: UIViewController {
    private let resolver: DiResolver
    private let manager: WishlistManager
    private let disposeBag = DisposeBag()
    private var castView: WishlistView { return view as! WishlistView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.manager = resolver.resolve(WishlistManager.self)
        super.init(nibName: nil, bundle: nil)
        
        automaticallyAdjustsScrollViewInsets = false
        
        manager.synchronize()
        manager.state.wishlistObservable.subscribeNext { [weak self] wishlist in
            self?.updateData(with: wishlist)
            }.addDisposableTo(disposeBag)
        manager.state.synchronizationStateObservable.subscribeNext { [weak self] synchronizing in
            self?.updateSynchronizing(with: synchronizing)
            }.addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WishlistView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        updateData(with: manager.state.wishlist)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.synchronize()
        logAnalyticsShowScreen(.Wishlist)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        markHandoffUrlActivity(withPath: "/c/wishlist")
        castView.refreshImagesIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    func updateData(with products: [WishlistProduct]) {
        logInfo("Updating data with products \(products)")
        castView.updateData(with: products, animated: !manager.state.synchronizationState.synchronizing)
        
        if products.count == 0 {
            castView.changeSwitcherState(.Empty)
            return
        }
    }
    
    func updateSynchronizing(with synchronizationState: WishlistSynchronizationState) {
        logInfo("Changed synchronizing state \(synchronizationState), products count \(manager.state.wishlist.count)")
        if manager.state.wishlist.count == 0 {
            castView.changeSwitcherState(.Empty)
        } else if synchronizationState.synchronizing {
            castView.changeSwitcherState(.ModalLoading)
        } else {
            castView.changeSwitcherState(.Success)
        }
    }
}

extension WishlistViewController: WishlistViewDelegate {
    func wishlistView(view: WishlistView, wantsDelete product: WishlistProduct) {
        logInfo("Deleted product \(product)")
        logAnalyticsEvent(AnalyticsEventId.WishlistProductDeleted(product.id))
        manager.removeFromWishlist(product)
    }
    
    func wishlistView(view: WishlistView, didSelectProductAt indexPath: NSIndexPath) {
        logInfo("Did select wishlist product at index: \(indexPath)")
        guard let context = manager.createWishlistProductsContext(indexPath.row, onChangedForIndex: { [unowned self] index in
            self.castView.moveToPosition(at: index, animated: false)
        }) else {
            return
        }
        
        logAnalyticsEvent(AnalyticsEventId.WishlistProductClicked(manager.state.wishlist[safe: indexPath.row]?.id ?? 0))
        
        sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: nil))
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("Did tap retry")
        manager.synchronize()
    }
}
