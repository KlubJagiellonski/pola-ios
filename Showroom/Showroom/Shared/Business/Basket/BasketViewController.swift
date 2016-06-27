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
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        manager.validate()
        manager.state.basketObservable.subscribeNext(updateBasket).addDisposableTo(disposeBag)
        manager.state.deliveryCarrierObservable.subscribeNext(updateCarrier).addDisposableTo(disposeBag)
        manager.state.deliveryCountryObservable.subscribeNext(updateCountry).addDisposableTo(disposeBag)
        manager.state.validationStateObservable.subscribeNext(updateValidating).addDisposableTo(disposeBag)
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
        
        updateBasket(with: manager.state.basket)
        castView.updateData(with: manager.state.deliveryCountry, and: manager.state.deliveryCarrier)
        castView.discountCode = manager.state.discountCode
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.validate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    func updateBasket(with basket: Basket?) {
        guard !isEmptyBasket(basket) else {
            castView.switcherState = .Empty
            return
        }
        
        castView.updateData(with: basket!)
    }
    
    func updateCarrier(with carrier: DeliveryCarrier?) {
        castView.updateData(with: manager.state.deliveryCountry, and: carrier)
    }
    
    func updateCountry(with country: DeliveryCountry?) {
        castView.updateData(with: country, and: manager.state.deliveryCarrier)
    }
    
    func updateValidating(with validationState: BasketValidationState) {
        castView.updateData(withValidated: validationState.validated)
        if isEmptyBasket(manager.state.basket) {
            castView.switcherState = .Empty
        } else if validationState.validating {
            castView.switcherState = castView.switcherState == .Error ? .Loading : .ModalLoading
        } else {
            castView.switcherState = validationState.validated ? .Success : .Error
        }
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
    
    func basketViewDidTapStartShoppingButton(view: BasketView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowSearch))
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        manager.validate()
    }
    
    // MARK: - Utilities
    
    func isEmptyBasket(basket: Basket?) -> Bool {
        return basket == nil || basket!.productsByBrands.isEmpty
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