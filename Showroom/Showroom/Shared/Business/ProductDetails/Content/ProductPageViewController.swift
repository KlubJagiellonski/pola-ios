import Foundation
import UIKit
import RxSwift

class ProductPageViewController: UIViewController {
    let model: ProductPageModel
    var castView: ProductPageView { return view as! ProductPageView }
    
    var viewContentInset: UIEdgeInsets?
    
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver) {
        model = resolver.resolve(ProductPageModel.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.contentInset = viewContentInset
        
        model.fetchProductDetails(1234).subscribeNext { [weak self] fetchResult in
            switch fetchResult {
            case .Success(let result):
                guard let owner = self else { return }
                owner.castView.updateModel(result, defaultSize: owner.model.defaultSize(forProductDetails: result), defaultColor: owner.model.defaultColor(forProductDetails: result))
            case .NetworkError(let errorType):
                logInfo("Error while downloading product info: \(errorType)")
            }
        }.addDisposableTo(disposeBag)
    }
}