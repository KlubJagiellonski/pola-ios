import UIKit

protocol ProductAmountViewControllerDelegate: class {
    func productAmount(viewController: ProductAmountViewController, didChangeAmountOf product: BasketProduct)
    func productAmountWantsDismiss(viewController: ProductAmountViewController, animated: Bool)
}

final class ProductAmountViewController: UIViewController, ProductAmountViewDelegate {
    var product: BasketProduct
    
    var castView: ProductAmountView { return view as! ProductAmountView }
    
    weak var delegate: ProductAmountViewControllerDelegate?
    
    init(resolver: DiResolver, product: BasketProduct) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductAmountView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(withMaxAmount: Constants.basketProductAmountLimit)
        castView.selectedIndex = product.amount
    }
    
    // MARK :- ProductAmountViewDelegate
    func productAmount(view: ProductAmountView, didSelectAmount amount: Int) {
        logInfo("Changing product amount \(amount) for product \(product)")
        product.amount = amount
        delegate?.productAmount(self, didChangeAmountOf: product)
    }
}

extension ProductAmountViewController: ExtendedModalViewController {
    func forceCloseWithoutAnimation() {
        delegate?.productAmountWantsDismiss(self, animated: false)
    }
}
