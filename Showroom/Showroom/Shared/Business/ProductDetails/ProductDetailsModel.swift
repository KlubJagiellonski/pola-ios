import Foundation
import RxSwift

class ProductDetailsModel {
    private var context: ProductDetailsContext
    private var disposeBag = DisposeBag()
    private let emarsysService: EmarsysService
    private var informAboutMovedToProduct = false
    let newProductsAmountObservable = PublishSubject<NewProductsAmount>()
    
    var initialProductIndex: Int {
        return context.initialProductIndex
    }
    
    var productsCount: Int {
        return context.productsCount
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
        emarsysService.sendViewEvent(forId: productInfo(forIndex: index).toTuple().0)
        if informAboutMovedToProduct {
            context.productDetailsDidMoveToProduct(atIndex: index)
        }
        informAboutMovedToProduct = true
    }
    
    func update(with context: ProductDetailsContext) {
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