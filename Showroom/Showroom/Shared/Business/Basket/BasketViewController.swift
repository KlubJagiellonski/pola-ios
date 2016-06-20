import Foundation
import UIKit
import RxSwift

class BasketViewController: UIViewController, BasketViewDelegate {
    private let disposeBag = DisposeBag()
    private let manager: BasketManager
    private var castView: BasketView { return view as! BasketView }
    private let resolver: DiResolver
    private let actionAnimator = DropUpActionAnimator(height: 216)
    private let deliveryAnimator =  FormSheetAnimator()
    
    // TODO: Remove sample basket when API is ready
    private let sampleBasketButton: UIButton = UIButton()
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        self.manager.basketObservable.subscribeNext(updateView).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BasketView()
        actionAnimator.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        
        // TODO: Remove sample basket when API is ready
        initSampleBasketButton()
    }
    
    private func updateView(with newBasket: Basket) {
        castView.updateData(with: newBasket)
        
        // TODO: Remove sample basket when API is ready
        updateSampleButtonVisibility()
    }
    
    // MARK: - BasketViewDelegate
    func basketViewDidDeleteProduct(product: BasketProduct) {
        manager.removeFromBasket(product)
    }
    
    func basketViewDidTapAmount(of product: BasketProduct) {
        let amountViewController = resolver.resolve(ProductAmountViewController.self, argument: product)
        amountViewController.delegate = self
        actionAnimator.presentViewController(amountViewController, presentingViewController: self, completion: nil)
    }
    
    func basketViewDidTapShipping(view: BasketView) {
        deliveryAnimator.delegate = self
        
        let viewController = resolver.resolve(BasketDeliveryNavigationController.self)
        viewController.deliveryDelegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 450)
        deliveryAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    func basketViewDidTapCheckoutButton(view: BasketView) {
        let viewController = resolver.resolve(CheckoutNavigationController.self)
        presentViewController(viewController, animated: true, completion: nil)
    }
}

extension BasketViewController: ProductAmountViewControllerDelegate {
    func productAmount(viewController: ProductAmountViewController, didChangeAmountOf product: BasketProduct) {
        actionAnimator.dismissViewController(presentingViewController: self, completion: nil)
        manager.updateInBasket(product)
    }
}

extension BasketViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        animator.dismissViewController(presentingViewController: self, completion: nil)
    }
}

extension BasketViewController: BasketDeliveryNavigationControllerDelegate {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController) {
        deliveryAnimator.dismissViewController(presentingViewController: self, completion: nil)
    }
}

// MARK: - Sample basket for testing
extension BasketViewController {
    private func initSampleBasketButton() {
        sampleBasketButton.setTitle("ADD SAMPLE PRODUCTS", forState: .Normal)
        sampleBasketButton.applyPlainStyle()
        sampleBasketButton.addTarget(self, action: #selector(BasketViewController.sampleButtonPressed(_:)), forControlEvents: .TouchUpInside)
        castView.addSubview(sampleBasketButton)
        
        sampleBasketButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func sampleButtonPressed(sender: UIButton) {
        manager.createSampleBasket()
        updateSampleButtonVisibility()
    }
    
    private func updateSampleButtonVisibility() {
        sampleBasketButton.hidden = !manager.currentBasket.isEmpty
    }
}