import Foundation
import RxSwift

class ProductListModel {
    let apiService: ApiService
    
    init(with apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchFirstPage() -> Observable<FetchResult<ProductListResult>> {
        return apiService.fetchProducts()
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
    }
    
    func fetchNextProductPage() -> Observable<FetchResult<ProductListResult>> {
        let products: [ListProduct] = [
            ListProduct(id: 1, brand: ProductBrand(id: 2, name: "ECHO"), name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 10119.00), price: Money(amt: 10089.00), imageUrl: "https://static.shwrm.net/images/7/l/7l5773d518c5c92_500x643.jpg", freeDelivery: true, premium: true, new: true),
            ListProduct(id: 2, brand: ProductBrand(id: 3, name: "Tomaotomo by Tomasz Olejniczak test"), name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 479.00), price: Money(amt: 218.00), imageUrl: "https://static.shwrm.net/images/p/5/p55772f826bed13_500x643.jpg", freeDelivery: true, premium: false, new: false)
        ]
        let result = ProductListResult(products: products, isLastPage: true)
        return Observable.just(FetchResult.Success(result)).delaySubscription(4, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)).observeOn(MainScheduler.instance)
    }
}