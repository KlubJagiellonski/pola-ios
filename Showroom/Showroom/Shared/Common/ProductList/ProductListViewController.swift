import Foundation
import UIKit
import RxSwift

protocol ProductListViewControllerInterface: class {
    var disposeBag: DisposeBag { get }
    var productListModel: ProductListModel { get }
    var productListView: ProductListViewInterface { get }
    var contentInset: UIEdgeInsets { get set }
    
    func fetchFirstPage()
    func fetchNextPage()
}

extension ProductListViewControllerInterface {
    var contentInset: UIEdgeInsets {
        set { productListView.contentInset = newValue }
        get { return productListView.contentInset }
    }
    
    func fetchFirstPage() {
        productListView.switcherState = .Loading
        let onNext = { [weak self] (result: FetchResult<ProductListResult>) in
            guard let `self` = self else { return }
            switch result {
            case .Success(let productListResult):
                logInfo("Received first product list page \(productListResult)")
                self.productListView.updateData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
                self.productListView.switcherState = productListResult.products.isEmpty ? .Empty : .Success
            case .NetworkError(let error):
                logInfo("Failed to receive first product list page \(error)")
                self.productListView.switcherState = .Error
            }
        }
        
        productListModel.fetchFirstPage().subscribeNext(onNext).addDisposableTo(disposeBag)
    }
    
    func fetchNextPage() {
        let onNext = { [weak self] (result: FetchResult<ProductListResult>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let productListResult):
                logInfo("Received next product list page \(productListResult)")
                strongSelf.productListView.appendData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
            case .NetworkError(let error):
                logInfo("Failed to receive next product list page \(error)")
                strongSelf.productListView.updateNextPageState(.Error)
            }
        }
        
        productListModel.fetchNextProductPage().subscribeNext(onNext).addDisposableTo(disposeBag)
    }
}

extension ProductListViewDelegate where Self : ProductListViewControllerInterface {
    func productListViewDidReachPageEnd(listView: ProductListViewInterface) {
        fetchNextPage()
    }
    
    func productListViewDidTapRetryPage(listView: ProductListViewInterface) {
        productListView.updateNextPageState(.Fetching)
        fetchNextPage()
    }
}