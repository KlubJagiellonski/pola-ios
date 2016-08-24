import Foundation
import RxSwift

class ProductDetailsModel {
    private var context: ProductDetailsContext
    private var disposeBag = DisposeBag()
    private let emarsysService: EmarsysService
    private var informAboutMovedToProduct = false
    let newProductsAmountObservable = PublishSubject<NewProductsAmount>()
    private var lastProductIndex: Int?
    
    var initialProductIndex: Int {
        return context.initialProductIndex
    }
    
    var productsCount: Int {
        return context.productsCount
    }
    
    var userSeenPagingInAppOnboarding: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userSeenPagingInAppOnboarding") }
        set {
            logInfo("userSeenPagingInAppOnboarding \(newValue)")
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userSeenPagingInAppOnboarding")
        }
    }
    
    init(context: ProductDetailsContext, emarsysService: EmarsysService) {
        self.context = context
        self.emarsysService = emarsysService
        
        configureContext()
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return context.productInfo(forIndex: index)
    }
    
    func didMoveToPage(atIndex index: Int) {
        logInfo("Did move to page \(index)")
        if let lastProductIndex = lastProductIndex {
            if index > lastProductIndex {
                logAnalyticsEvent(AnalyticsEventId.ProductSwitchedWithRightSwipe(context.fromType.rawValue))
            } else if index < lastProductIndex {
                logAnalyticsEvent(AnalyticsEventId.ProductSwitchedWithLeftSwipe(context.fromType.rawValue))
            }
        }
        lastProductIndex = index
        
        emarsysService.sendViewEvent(forId: productInfo(forIndex: index).toTuple().0)
        if informAboutMovedToProduct {
            context.productDetailsDidMoveToProduct(atIndex: index)
        }
        informAboutMovedToProduct = true
    }
    
    func update(with context: ProductDetailsContext) {
        logInfo("Updating context \(context)")
        disposeBag = DisposeBag()
        self.context = context
        configureContext()
        informAboutMovedToProduct = false
    }
    
    private func configureContext() {
        context.newProductsObservable.subscribeNext { [weak self] newProductsAmount in
            self?.newProductsAmountObservable.onNext(newProductsAmount)
            }.addDisposableTo(disposeBag)
    }
}