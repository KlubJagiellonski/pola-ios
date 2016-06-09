import UIKit

protocol ProductSizeViewControllerDelegate: class {
    func productSize(viewController: ProductSizeViewController, didChangeSize sizeId: ObjectId)
    func productSizeDidTapSizes(viewController: ProductSizeViewController)
}

class ProductSizeViewController: UIViewController, ProductSizeViewDelegate {
    let sizes: [ProductSize]
    let initialSelectedSizeId: ObjectId?
    
    var castView: ProductSizeView { return view as! ProductSizeView }
    
    weak var delegate: ProductSizeViewControllerDelegate?
    
    init(resolver: DiResolver, sizes: [ProductSize], initialSelectedSizeId: ObjectId?) {
        self.sizes = sizes
        self.initialSelectedSizeId = initialSelectedSizeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductSizeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(sizes)
        castView.selectedIndex = sizes.indexOf { $0.id == initialSelectedSizeId }
    }

    // MARK :- ProductSizeViewDelegate
    
    func productSize(view: ProductSizeView, didSelectSize sizeId: ObjectId) {
        delegate?.productSize(self, didChangeSize: sizeId)
    }
    
    func productSizeDidTapSizes(view: ProductSizeView) {
        delegate?.productSizeDidTapSizes(self)
    }
}
