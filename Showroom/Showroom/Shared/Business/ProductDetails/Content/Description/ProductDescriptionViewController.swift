import Foundation
import UIKit

class ProductDescriptionViewController: UIViewController {
    let modelState: ProductPageModelState
    
    var castView: ProductDescriptionView { return view as! ProductDescriptionView }
    var viewContentInset: UIEdgeInsets?
    
    init(modelState: ProductPageModelState) {
        self.modelState = modelState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductDescriptionView(modelState: modelState)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.contentInset = viewContentInset
    }
}