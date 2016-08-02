import Foundation
import UIKit
import RxSwift

class BasketViewController: UIViewController, BasketViewDelegate {
    private let disposeBag = DisposeBag()
    private let manager: BasketManager
    private let toastManager: ToastManager
    private var castView: BasketView { return view as! BasketView }
    private let resolver: DiResolver
    private let actionAnimator = DropUpActionAnimator(height: 216)
    private let deliveryAnimator = FormSheetAnimator()
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        self.toastManager = resolver.resolve(ToastManager.self)
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
        logAnalyticsShowScreen(.Basket)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
        markHandoffUrlActivity(withPath: "/c/cart/view")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    func updateBasket(with basket: Basket?) {
        if let basket = basket {
            castView.updateData(with: basket)
        }
        
        guard !isEmptyBasket(basket) else {
            castView.switcherState = .Empty
            return
        }
        
        guard presentedViewController == nil else {
            logInfo("Cannot show basket toast, when it shows presented controller")
            return
        }
        
        if let updateInfo = castView.lastUpdateInfo where manager.state.validationState.validating {
            let messages = updateInfo.toMessages(withDiscountErrors: manager.state.basket?.discountErrors)
            if messages.count > 0 {
                logInfo("will show update info messages \(messages)")
                toastManager.showMessages(messages)
            }
        }
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
    
    private func goToCheckout() {
        guard manager.isUserLogged else {
            let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
            viewController.signingDelegate = self
            presentViewController(viewController, animated: true, completion: nil)
            return
        }
        guard let checkout = manager.createCheckout() else { return }
        
        let viewController = resolver.resolve(CheckoutNavigationController.self, argument: checkout)
        viewController.checkoutDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
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
        goToCheckout()
    }
    
    func basketView(view: BasketView, didChangeDiscountCode discountCode: String?) {
        guard discountCode != manager.state.discountCode else { return }
        if let discountCode = discountCode?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            manager.state.discountCode = discountCode.characters.count > 0 ? discountCode : nil
        } else {
            manager.state.discountCode = nil
        }
        manager.validate()
    }
    
    func basketViewDidTapStartShoppingButton(view: BasketView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowSearch))
    }
    
    func basketView(view: BasketView, didSelectProductAtIndexPath indexPath: NSIndexPath) {
        let context = manager.createBasketProductListContext(indexPath) { [unowned self] indexPath in
            self.castView.moveToPosition(at: indexPath, animated: false)
        }
        guard let c = context else { return }
        sendNavigationEvent(ShowProductDetailsEvent(context: c, retrieveCurrentImageViewTag: nil))
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
        animator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension BasketViewController: BasketDeliveryNavigationControllerDelegate {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController) {
        deliveryAnimator.dismissViewController(presentingViewController: self, completion: nil)
    }
}

extension BasketViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true) { [weak self] in
            self?.goToCheckout()
        }
    }
}

extension BasketViewController: CheckoutNavigationControllerDelegate {
    func checkoutWantsGoToMainScreen(checkout: CheckoutNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    func checkoutWantsDismiss(checkout: CheckoutNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension BasketUpdateInfo {
    private func toMessages(withDiscountErrors discountErrors: [String]?) -> [String] {
        var messages: [String] = []
        if let message = createMessage(tr(.BasketErrorProductsRemoved), items: removedProductInfo) {
            messages.append(message)
        }
        if let message = createMessage(tr(.BasketErrorProductsAmountChanged), items: changedProductAmountInfo) {
            messages.append(message)
        }
        if let message = createMessage(tr(.BasketErrorPriceChanged), items: changedProductPriceInfo) {
            messages.append(message)
        }
        if let message = createMessage(tr(.BasketErrorDeilveryInfoChanged), items: changedBrandDeliveryInfo) {
            messages.append(message)
        }
        if let discountErrors = discountErrors, let message = createMessage(tr(.BasketErrorInvalidDiscountCode), items: discountErrors) {
            messages.append(message)
        }
        return messages
    }
    
    private func createMessage(title: String, items: [String]) -> String? {
        guard !items.isEmpty else { return nil }
        
        let lineSeparator = "\n"
        var message = title + lineSeparator
        for info in items {
            message += "- " + info + lineSeparator
        }
        message = message.substringToIndex(message.endIndex.advancedBy(-lineSeparator.characters.count))
        return message
    }
}