import Foundation
import RxSwift

class ProductDetailsModel {
    private let context: ProductDetailsContext
    private let disposeBag = DisposeBag()
    private var informAboutMovedToProduct = false
    let newProductsAmountObservable = PublishSubject<NewProductsAmount>()
    
    var initialProductIndex: Int {
        return context.initialProductIndex
    }
    
    var productsCount: Int {
        return context.productsCount
    }
    
    init(context: ProductDetailsContext) {
        self.context = context
        context.newProductsObservable.subscribeNext { [weak self] newProductsAmount in
            self?.newProductsAmountObservable.onNext(newProductsAmount)
        }.addDisposableTo(disposeBag)
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return context.productInfo(forIndex: index)
    }
    
    func didMoveToPage(atIndex index: Int) {
        if informAboutMovedToProduct {
            context.productDetailsDidMoveToProduct(atIndex: index)
        }
        informAboutMovedToProduct = true
    }
}