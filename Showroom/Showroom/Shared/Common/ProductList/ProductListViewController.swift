import Foundation
import UIKit
import RxSwift

protocol ProductListViewControllerInterface: class, NavigationSender, ExtendedViewController {
    var disposeBag: DisposeBag { get }
    var productListModel: ProductListModel { get }
    var productListView: ProductListViewInterface { get }
    
    func fetchFirstPage()
    func fetchNextPage()
    func pageWasFetched(result productListResult: ProductListResult, page: Int) //it is used to inform viewcontroller that first page has been fetched. You can do some additional stuff here
}

extension ProductListViewControllerInterface {
    func fetchFirstPage() {
        productListView.switcherState = .Loading
        let onNext = { [weak self] (result: FetchResult<ProductListResult>) in
            guard let `self` = self else { return }
            switch result {
            case .Success(let productListResult):
                logInfo("Received first product list page \(productListResult)")
                self.pageWasFetched(result: productListResult, page: self.productListModel.currentPageIndex)
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
            guard let `self` = self else { return }
            switch result {
            case .Success(let productListResult):
                logInfo("Received next product list page \(productListResult)")
                self.pageWasFetched(result: productListResult, page: self.productListModel.currentPageIndex)
                self.productListView.appendData(productListResult.products, nextPageState: productListResult.isLastPage ? .LastPage : .Fetching)
            case .NetworkError(let error):
                logInfo("Failed to receive next product list page \(error)")
                self.productListView.updateNextPageState(.Error)
            }
        }
        
        productListModel.fetchNextProductPage().subscribeNext(onNext).addDisposableTo(disposeBag)
    }
    
    //call it in viewDidLoad
    func configureProductList() {
        productListModel.isBigScreen = UIScreen.mainScreen().bounds.width >= ProductListComponent.threeColumnsRequiredWidth
        productListModel.productIndexObservable.subscribeNext { [weak self] (index: Int) in
            self?.productListView.moveToPosition(forProductIndex: index, animated: false)
            }.addDisposableTo(disposeBag)
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
    
    func productListView(listView: ProductListViewInterface, didTapProductAtIndex index: Int) {
        let imageWidth = productListView.productImageWidth
        let context = productListModel.createProductDetailsContext(withProductIndex: index, withImageWidth: imageWidth)
        sendNavigationEvent(ShowProductDetailsEvent(context: context))
    }
    
    func productListView(listView: ProductListViewInterface, didDoubleTapProductAtIndex index: Int) {
        //todo
    }
}

//TODO remove when api

extension ProductListViewControllerInterface {
    var mockedFilter: Filter {
        let sortOptions = [
            FilterSortOption(id: 1, name: "Wybór projektanta"),
            FilterSortOption(id: 2, name: "Nowości"),
            FilterSortOption(id: 3, name: "Cena od najniższej"),
            FilterSortOption(id: 4, name: "Cena od najwyższej")
        ]
        let selectedSortOption = 1
        let filterCategories = [
            FilterCategory(id: 1, name: "Wszystkie buty", hasChildCategories: false),
            FilterCategory(id: 2, name: "Balerinki", hasChildCategories: true),
            FilterCategory(id: 3, name: "Botki", hasChildCategories: true),
            FilterCategory(id: 4, name: "Kozaki", hasChildCategories: true),
            FilterCategory(id: 5, name: "Oksfordki", hasChildCategories: true),
            FilterCategory(id: 6, name: "Sandały i klapki", hasChildCategories: true),
            FilterCategory(id: 7, name: "Szpilki", hasChildCategories: false)
        ]
        let selectedFilterCategory = 1
        
        let sizes = [
            FilterSize(id: 1, name: "onesize"),
            FilterSize(id: 2, name: "M"),
            FilterSize(id: 3, name: "36"),
            FilterSize(id: 4, name: "38"),
            FilterSize(id: 5, name: "40"),
            FilterSize(id: 6, name: "XXS"),
            ]
        let colors = [
            FilterColor(id: 1, name: "Beżowy", type: .RGB, value: "FAFAFA"),
            FilterColor(id: 2, name: "Biały", type: .RGB, value: "FFFFFF"),
            FilterColor(id: 3, name: "Czarny", type: .RGB, value: "000000"),
            FilterColor(id: 4, name: "Pstrokaty", type: .Image, value: "https://placehold.it/50x50/888888/ffffff"),
            ]
        let selectedColors = [
            1
        ]
        
        let brands = [
            FilterBrand(id: 1, name: "10 DECOART"),
            FilterBrand(id: 2, name: "4LCK"),
            FilterBrand(id: 3, name: "9fashion Woman"),
            FilterBrand(id: 4, name: "A2"),
            FilterBrand(id: 5, name: "Afriq Password"),
            FilterBrand(id: 6, name: "Afunguard"),
            ]
        let selectedBrands = [1, 2, 3, 4, 5, 6]
        
        let mockedFilter = Filter(sortOptions: sortOptions, selectedSortOptionId: selectedSortOption, defaultSortOptionId:3, categories: filterCategories, selectedCategoryId:selectedFilterCategory, sizes: sizes, selectedSizeIds: [], colors: colors, selectedColorIds: selectedColors, priceRange: PriceRange(min: Money(amt: 0.0), max: Money(amt:1000.0)), selectedPriceRange: nil, onlyDiscountsSelected: true, brands: brands, selectedBrandIds: selectedBrands)
        return mockedFilter
    }
}