import Foundation
import UIKit
import RxSwift

class BrandProductListViewController: UIViewController, ProductListViewControllerInterface, BrandProductListViewDelegate {
    private let resolver: DiResolver
    let disposeBag = DisposeBag()
    let productListModel: ProductListModel
    private var brandListModel: BrandProductListModel { return productListModel as! BrandProductListModel }
    var productListView: ProductListViewInterface { return castView }
    private var castView: BrandProductListView { return view as! BrandProductListView }
    
    init(with resolver: DiResolver, and brand: EntryProductBrand) {
        self.resolver = resolver
        productListModel = resolver.resolve(BrandProductListModel.self, argument: brand)
        super.init(nibName: nil, bundle: nil)
        
        title = brand.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BrandProductListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        
        configureProductList()
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
    }
    
    func didTapFilterButton() {
        let viewController = resolver.resolve(ProductFilterNavigationController.self, argument: mockedFilter)
        viewController.filterDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func pageWasFetched(result productListResult: ProductListResult, page: Int) {
        if let brand = brandListModel.brand {
            title = brand.name
        }
        if let description = brandListModel.description, let brand = brandListModel.brand where page == 0 {
            castView.updateBrandInfo(brand.imageUrl, description: description)
        }
    }
    func filterButtonEnableStateChanged(toState enabled: Bool) { }
    
    // MARK:- BrandProductListViewDelegate
    
    func brandProductListDidTapHeader(view: BrandProductListView) {
        guard let brand = brandListModel.brand else { return }
        let imageWidth = castView.headerImageWidth
        let lowResImageUrl = NSURL.createImageUrl(brand.imageUrl, width: imageWidth, height: nil)
        sendNavigationEvent(ShowBrandDescriptionEvent(brand: brand.appendLowResImageUrl(lowResImageUrl.absoluteString)))
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}

extension BrandProductListViewController: ProductFilterNavigationControllerDelegate {}

