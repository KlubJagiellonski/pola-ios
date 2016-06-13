import Foundation
import RxSwift

class ProductDetailsModel {
    private let context: ProductDetailsContext
    private let disposeBag = DisposeBag()
    let productInfosObservable = PublishSubject<[ProductInfo]>()

    var productInfos: [ProductInfo] {
        return context.productInfos
    }
    
    var initialProductIndex: Int {
        return context.initialProductIndex
    }
    
    init(context: ProductDetailsContext) {
        self.context = context
        context.productInfosObservable.subscribeNext { [weak self] products in
            self?.productInfosObservable.onNext(products)
        }.addDisposableTo(disposeBag)
    }
    
    func didMoveToPage(atIndex index: Int) {
        context.productDetailsDidMoveToProduct(atIndex: index)
    }
}