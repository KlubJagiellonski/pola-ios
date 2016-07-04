import Foundation
import RxSwift

class ProductListModel {
    let apiService: ApiService
    private var page = 1
    
    init(with apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchFirstPage() -> Observable<FetchResult<ProductListResult>> {
        page = 1
        return apiService.fetchProducts(page)
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
    }
    
    func fetchNextProductPage() -> Observable<FetchResult<ProductListResult>> {
        return apiService.fetchProducts(page + 1)
            .doOnNext { [weak self] _ in self?.page += 1 }
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
    }
}