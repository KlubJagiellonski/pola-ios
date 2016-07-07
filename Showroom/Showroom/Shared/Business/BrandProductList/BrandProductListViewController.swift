import Foundation
import UIKit
import RxSwift

class BrandProductListViewController: UIViewController, ProductListViewControllerInterface, BrandProductListViewDelegate {
    let disposeBag = DisposeBag()
    let productListModel: ProductListModel
    var brandListModel: BrandProductListModel { return productListModel as! BrandProductListModel }
    var productListView: ProductListViewInterface { return castView }
    var castView: BrandProductListView { return view as! BrandProductListView }
    
    init(with resolver: DiResolver, and brand: ProductBrand) {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
        
        castView.delegate = self
        
        fetchFirstPage()
        
        configureProductList()
    }
    
    func didTapFilterButton() {
        //todo
    }
    
    func pageWasFetched(result productListResult: ProductListResult, page: Int) {
        if let description = brandListModel.description, let brand = brandListModel.brand where page == 0 {
            castView.updateBrandInfo(brand.imageUrl, description: description)
        }
    }
    
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