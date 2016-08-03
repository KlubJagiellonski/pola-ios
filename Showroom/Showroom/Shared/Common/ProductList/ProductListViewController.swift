import Foundation
import UIKit
import RxSwift

protocol ProductListViewControllerInterface: class, NavigationSender, ExtendedViewController {
    associatedtype EntryData
    
    var disposeBag: DisposeBag { get }
    var productListModel: ProductListModel { get }
    var productListView: ProductListViewInterface { get }
    var filterButtonVisible: Bool { get set }
    var filterButtonEnabled: Bool { get set }
    
    func updateData(with data: EntryData)
    func createFilterButton() -> UIBarButtonItem?
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) // it is used to inform viewcontroller that first page has been fetched. You can do some additional stuff here
    func filterButtonEnableStateChanged(toState enabled: Bool)
}

extension ProductListViewControllerInterface {
    func fetchFirstPage() {
        productListView.switcherState = .Loading
        filterButtonEnabled = false
        let onEvent = { [weak self](event: Event<ProductListResult>) in
            guard let `self` = self else { return }
            switch event {
            case .Next(let productListResult):
                logInfo("Received first product list page \(productListResult)")
                self.pageWasFetched(result: productListResult, pageIndex: self.productListModel.currentPageIndex)
                self.productListView.updateData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
                self.productListView.switcherState = productListResult.products.isEmpty ? .Empty : .Success
                self.filterButtonVisible = productListResult.filters != nil
                self.filterButtonEnabled = true
            case .Error(let error):
                logInfo("Failed to receive first product list page \(error)")
                self.productListView.switcherState = .Error
            default: break
            }
        }
        
        productListModel.fetchFirstPage().subscribe(onEvent).addDisposableTo(disposeBag)
    }
    
    func fetchNextPage() {
        let onEvent = { [weak self](event: Event<ProductListResult>) in
            guard let `self` = self else { return }
            switch event {
            case .Next(let productListResult):
                logInfo("Received next product list page \(productListResult)")
                self.pageWasFetched(result: productListResult, pageIndex: self.productListModel.currentPageIndex)
                self.productListView.appendData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
            case .Error(let error):
                logInfo("Failed to receive next product list page \(error)")
                self.productListView.updateNextPageState(.Error)
            default: break
            }
        }
        
        productListModel.fetchNextProductPage().subscribe(onEvent).addDisposableTo(disposeBag)
    }
    
    func didChangeFilter(withResult productListResult: ProductListResult) {
        logInfo("Changed filter with productListResult \(productListResult)")
        productListModel.didChangeFilter(withResult: productListResult)
        updateDataOnFirstPageFetched(productListResult)
    }
    
    // call it in viewDidLoad
    func configureProductList() {
        filterButtonVisible = true
        productListModel.isBigScreen = UIScreen.mainScreen().bounds.width >= ProductListComponent.threeColumnsRequiredWidth
        productListModel.productIndexObservable.subscribeNext { [weak self] (index: Int?) in
            guard let index = index else { return }
            self?.productListView.moveToPosition(forProductIndex: index, animated: false)
        }.addDisposableTo(disposeBag)
    }
    
    private func updateDataOnFirstPageFetched(productListResult: ProductListResult) {
        self.pageWasFetched(result: productListResult, pageIndex: self.productListModel.currentPageIndex)
        self.productListView.updateData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
        self.productListView.switcherState = productListResult.products.isEmpty ? .Empty : .Success
        self.filterButtonVisible = productListResult.filters != nil
        self.filterButtonEnabled = true
    }
}

extension ProductListViewControllerInterface where Self: UIViewController {
    var filterButtonVisible: Bool {
        set {
            guard newValue != filterButtonVisible else { return }
            
            let button: UIBarButtonItem? = newValue ? createFilterButton() : nil
            navigationItem.rightBarButtonItem = button
        }
        get {
            return navigationItem.rightBarButtonItem != nil
        }
    }
    var filterButtonEnabled: Bool {
        set {
            navigationItem.rightBarButtonItem?.enabled = newValue
            filterButtonEnableStateChanged(toState: newValue)
        }
        get {
            return navigationItem.rightBarButtonItem?.enabled ?? false
        }
    }
}

extension ProductListViewDelegate where Self: ProductListViewControllerInterface {
    func productListViewDidReachPageEnd(listView: ProductListViewInterface) {
        fetchNextPage()
    }
    
    func productListViewDidTapRetryPage(listView: ProductListViewInterface) {
        productListView.updateNextPageState(.Fetching)
        fetchNextPage()
    }
    
    func productListView(listView: ProductListViewInterface, didTapProductAtIndex index: Int) {
        logAnalyticsEvent(AnalyticsEventId.ListProductClicked(productListModel.products[safe: index]?.id ?? 0))
        let imageWidth = productListView.productImageWidth
        let context = productListModel.createProductDetailsContext(withProductIndex: index, withImageWidth: imageWidth)
        let retrieveCurrentImageViewTag: () -> Int? = { [weak self] in
            guard let `self` = self else { return nil }
            guard let index = self.productListModel.productIndex else { return nil }
            return self.productListView.imageTag(forIndex: index)
        }
        sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: retrieveCurrentImageViewTag))
    }
    
    func productListView(listView: ProductListViewInterface, didDoubleTapProductAtIndex index: Int) {
        logAnalyticsEvent(AnalyticsEventId.ListAddToWishlist(productListModel.products[safe: index]?.id ?? 0))
        productListModel.addToWishlist(productAtIndex: index)
    }
}