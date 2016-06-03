import UIKit

protocol ProductSizeViewControllerDelegate: class {
    func productSize(viewController: ProductSizeViewController, didChangeSize size: String)
    func productSizeDidTapSizes(viewController: ProductSizeViewController)
}

class ProductSizeViewController: UIViewController, ProductSizeViewDelegate {
    let sizes: [ProductSize] = [
        ProductSize(id: 0, size: "XXS", isAvailable: true),
        ProductSize(id: 1, size: "XS", isAvailable: true),
        ProductSize(id: 2, size: "S", isAvailable: false),
        ProductSize(id: 3, size: "M", isAvailable: true),
        ProductSize(id: 4, size: "L", isAvailable: true),
        ProductSize(id: 5, size: "XL", isAvailable: false),
        ProductSize(id: 6, size: "XXXL", isAvailable: true)
    ]   //temporary data source
    
    var castView: ProductSizeView { return view as! ProductSizeView }
    
    weak var delegate: ProductSizeViewControllerDelegate?
    
    override func loadView() {
        view = ProductSizeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(sizes)
    }
    
    init(resolver: DiResolver) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK :- ProductSizeViewDelegate
    
    func productSize(view: ProductSizeView, didSelectSize size: String) {
        delegate?.productSize(self, didChangeSize: size)
    }
    
    func productSizeDidTapSizes(view: ProductSizeView) {
        delegate?.productSizeDidTapSizes(self)
    }
}
