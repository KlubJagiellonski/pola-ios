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
        
        manager.validate()
        manager.state.basketObservable.subscribeNext(castView.updateData).addDisposableTo(disposeBag)
        manager.state.deliveryCarrierObservable.subscribeNext(updateCarrier).addDisposableTo(disposeBag)
        manager.state.deliveryCountryObservable.subscribeNext(updateCountry).addDisposableTo(disposeBag)
        manager.state.validatedObservable.subscribeNext(castView.updateData).addDisposableTo(disposeBag)
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
        
        castView.updateData(with: manager.state.basket)
        castView.updateData(with: manager.state.deliveryCountry, and: manager.state.deliveryCarrier)
        castView.discountCode = manager.state.discountCode
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    func updateCarrier(with carrier: DeliveryCarrier?) {
        castView.updateData(with: manager.state.deliveryCountry, and: carrier)
    }
    
    func updateCountry(with country: DeliveryCountry?) {
        castView.updateData(with: country, and: manager.state.deliveryCarrier)
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
    
    func basketView(view: BasketView, didChangeDiscountCode discountCode: String?) {
        guard discountCode != manager.state.discountCode else { return }
        manager.state.discountCode = discountCode
        manager.validate()
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