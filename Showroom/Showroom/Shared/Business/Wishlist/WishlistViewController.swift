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
        manager.state.wishlistObservable.subscribeNext(updateData).addDisposableTo(disposeBag)
        manager.state.synchronizationStateObservable.subscribeNext(updateSynchronizing).addDisposableTo(disposeBag)
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    func updateData(with products: [ListProduct]) {
        castView.updateData(with: products)
        
        if products.count == 0 {
            castView.switcherState = .Empty
            return
        }
    }
    
    func updateSynchronizing(with synchronizationState: WishlistSynchronizationState) {
        if manager.state.wishlist.count == 0 {
            castView.switcherState = .Empty
        } else if synchronizationState.synchronizing {
            castView.switcherState = .ModalLoading
        } else {
            castView.switcherState = .Success
        }
    }
}

extension WishlistViewController: WishlistViewDelegate {
    func wishlistView(view: WishlistView, wantsDelete product: ListProduct) {
        logAnalyticsEvent(AnalyticsEventId.WishlistProductDeleted(product.id))
        manager.removeFromWishlist(product)
    }
    
    func wishlistView(view: WishlistView, didSelectProductAt indexPath: NSIndexPath) {
        guard let context = manager.createWishlistProductsContext(indexPath.row, onChangedForIndex: { [unowned self] index in
            self.castView.moveToPosition(at: index, animated: false)
        }) else {
            return
        }
        
        logAnalyticsEvent(AnalyticsEventId.WishlistProductClicked(manager.state.wishlist[safe: indexPath.row]?.id ?? 0))
        
        sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: nil))
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        manager.synchronize()
    }
}
