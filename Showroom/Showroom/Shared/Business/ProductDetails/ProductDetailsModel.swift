import Foundation
import RxSwift

class ProductDetailsModel {
    private(set) var context: ProductDetailsContext
    private var disposeBag = DisposeBag()
    let productsCountObservable = PublishSubject<ProductsCount>()
    private var lastProductIndex: Int?
    
    var initialProductIndex: Int {
        return context.initialProductIndex
    }
    
    var productsCount: Int {
        return context.productsCount
    }
    
    var shouldShowInAppOnboarding: Bool {
        return context.productsCount > 1
    }
    
    init(context: ProductDetailsContext) {
        self.context = context
        
        configureContext()
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo? {
        return context.productInfo(forIndex: index)
    }
    
    func didMoveToPage(atIndex index: Int) {
        logInfo("Did move to page \(index)")
        
        if let lastProductIndex = lastProductIndex {
            informAboutMovingToPage(atIndex: index, fromIndex: lastProductIndex)
        } else if index != initialProductIndex {
            informAboutMovingToPage(atIndex: index, fromIndex: initialProductIndex)
        }
        lastProductIndex = index
    }
    
    func update(with context: ProductDetailsContext) {
        logInfo("Updating context \(context)")
        disposeBag = DisposeBag()
        self.context = context
        configureContext()
        lastProductIndex = nil
    }
    
    private func configureContext() {
        context.productsCountObservable.subscribeNext { [weak self] productsCount in
            self?.productsCountObservable.onNext(productsCount)
            }.addDisposableTo(disposeBag)
    }
    
    private func informAboutMovingToPage(atIndex toIndex: Int, fromIndex: Int) {
        if toIndex > fromIndex {
            logAnalyticsEvent(AnalyticsEventId.ProductSwitchedWithRightSwipe(context.fromType.rawValue))
        } else if toIndex < fromIndex {
            logAnalyticsEvent(AnalyticsEventId.ProductSwitchedWithLeftSwipe(context.fromType.rawValue))
        }
        
        context.productDetailsDidMoveToProduct(atIndex: toIndex)
    }
}
