import Foundation
import RxSwift

class ProductPageModel {
    let api: ApiService
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchProductDetails(id: Int) -> Observable<FetchResult<ProductDetails>> {
        return api.fetchProductDetails(withProductId: id)
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
    }
    
    func defaultSize(forProductDetails productDetails: ProductDetails) -> ProductDetailsSize? {
        return productDetails.sizes.first
    }
    
    func defaultColor(forProductDetails productDetails: ProductDetails) -> ProductDetailsColor? {
        guard let size = defaultSize(forProductDetails: productDetails) else { return nil }
        guard let colorId = size.colors.first else { return nil }
        return productDetails.colors.find { $0.id == colorId }
    }
}