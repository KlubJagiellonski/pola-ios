import Foundation
import UIKit
import RxSwift

class CategoryProductListViewController: UIViewController, ProductListViewControllerInterface, CategoryProductListViewDelegate {
    let disposeBag = DisposeBag()
    let productListModel: ProductListModel
    var categoryListModel: CategoryProductListModel { return productListModel as! CategoryProductListModel }
    var productListView: ProductListViewInterface { return castView }
    var castView: CategoryProductListView { return view as! CategoryProductListView }
    
    init(withResolver resolver: DiResolver, category: Category) {
        productListModel = resolver.resolve(CategoryProductListModel.self, argument: category)
        super.init(nibName: nil, bundle: nil)
        
        title = categoryListModel.category.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CategoryProductListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
        
        castView.delegate = self
        
        configureProductList()
        fetchFirstPage()
    }
    
    func didTapFilterButton() {
        //todo
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}