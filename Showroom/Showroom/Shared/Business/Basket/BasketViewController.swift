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
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        
        updateBasket(with: manager.state.basket)
        castView.updateData(with: manager.state.deliveryCountry, and: manager.state.deliveryCarrier)
        castView.discountCode = manager.state.discountCode
        
        manager.state.basketObservable.subscribeNext { [weak self] basket in
            self?.updateBasket(with: basket)
            }.addDisposableTo(disposeBag)
        manager.state.deliveryCarrierObservable.subscribeNext { [weak self] carrier in
            self?.updateCarrier(with: carrier)
        }.addDisposableTo(disposeBag)
        manager.state.deliveryCountryObservable.subscribeNext { [weak self] country in
            self?.updateCountry(with: country)
            }.addDisposableTo(disposeBag)
        manager.state.validationStateObservable.subscribeNext { [weak self] validating in
            self?.updateValidating(with: validating)
            }.addDisposableTo(disposeBag)
        manager.state.resetDiscountCodeObservable.subscribeNext { [weak self] in
            self?.castView.resetDiscountCodeValue()
        }.addDisposableTo(disposeBag)
        
        manager.validate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.validate()
        logAnalyticsShowScreen(.Basket)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
        markHandoffUrlActivity(withPathComponent: "c/cart/view", resolver: resolver)
        castView.deselectRowsIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    func updateBasket(with basket: Basket?) {
        logInfo("Updating basket \(basket)")
        if let basket = basket {
            castView.updateData(with: basket)
        }
        
        guard !isEmptyBasket(basket) else {
            logInfo("Empty basket")
            castView.changeSwitcherState(.Empty)
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
        logInfo("Updating carrier \(carrier)")
        castView.updateData(with: manager.state.deliveryCountry, and: carrier)
    }
    
    func updateCountry(with country: DeliveryCountry?) {
        logInfo("Updating country \(country)")
        castView.updateData(with: country, and: manager.state.deliveryCarrier)
    }
    
    func updateValidating(with validationState: BasketValidationState) {
        let basketEmpty = isEmptyBasket(manager.state.basket)
        logInfo("Updating validate \(validationState) basketEmpty \(basketEmpty)")
        castView.updateData(withValidated: validationState.validated)
        if basketEmpty {
            castView.changeSwitcherState(.Empty)
        } else if validationState.validating {
            castView.changeSwitcherState(castView.switcherState == .Error ? .Loading : .ModalLoading)
        } else {
            castView.changeSwitcherState(validationState.validated ? .Success : .Error)
        }
    }
    
    func didReceiveNewDiscountCode(discountCode: String, link: NSURL?) {
        logInfo("Received new discount code \(discountCode)")
        logAnalyticsShowScreen(.Basket, refferenceUrl: link)
        castView.discountCode = discountCode
        didChangeDiscountCode(discountCode)
        if isEmptyBasket(manager.state.basket) { //when empty view
            toastManager.showMessage(tr(.BasketCouponCodeAddedToBasket(discountCode)))
        }
    }
    
    private func didChangeDiscountCode(discountCode: String?) {
        logInfo("Did change discount code \(discountCode)")
        guard discountCode != manager.state.discountCode else {
            logInfo("Discount code is the same as before")
            return
        }
        if let discountCode = discountCode?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            manager.state.discountCode = discountCode.characters.isEmpty ? nil : discountCode
            logAnalyticsEvent(.CartDiscountSubmitted(manager.state.discountCode ?? ""))
        } else {
            manager.state.discountCode = nil
        }
        manager.validate()
    }
    
    private func goToCheckout() {
        logInfo("Going to checkout")
        guard manager.isUserLogged else {
            logInfo("User need to login")
            let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
            viewController.signingDelegate = self
            presentViewController(viewController, animated: true, completion: nil)
            return
        }
        guard let checkout = manager.createCheckout() else {
            logInfo("Cannot create checkout")
            return
        }
        logInfo("Checkout created \(checkout)")
        
        logAnalyticsEvent(AnalyticsEventId.CartGoToCheckoutClicked(checkout.basket.price))
        
        let viewController = resolver.resolve(CheckoutNavigationController.self, argument: checkout)
        viewController.checkoutDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: - BasketViewDelegate
    func basketViewDidDeleteProduct(product: BasketProduct) {
        logInfo("Deleting product \(product)")
        logAnalyticsEvent(.CartProductDeleted(product.id))
        manager.removeFromBasket(product)
    }
    
    func basketViewDidTapAmount(of product: BasketProduct) {
        logInfo("Did tap amount \(product)")
        let amountViewController = resolver.resolve(ProductAmountViewController.self, argument: product)
        amountViewController.delegate = self
        actionAnimator.presentViewController(amountViewController, presentingViewController: self, completion: nil)
    }
    
    func basketViewDidTapShipping(view: BasketView) {
        logInfo("did tap shipping")
        deliveryAnimator.delegate = self
        
        let viewController = resolver.resolve(BasketDeliveryNavigationController.self)
        viewController.deliveryDelegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 450)
        deliveryAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    func basketViewDidTapCheckoutButton(view: BasketView) {
        logInfo("Did tap checkout button")
        goToCheckout()
    }
    
    func basketView(view: BasketView, didChangeDiscountCode discountCode: String?) {
        didChangeDiscountCode(discountCode)
    }
    
    func basketViewDidTapStartShoppingButton(view: BasketView) {
        logInfo("Did tap start shopping button")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowSearch))
    }
    
    func basketView(view: BasketView, didSelectProductAtIndexPath indexPath: NSIndexPath) {
        logInfo("Did select product at indexPath \(indexPath)")
        let context = manager.createBasketProductListContext(indexPath) { [unowned self] indexPath in
            logInfo("Move to position \(indexPath)")
            self.castView.moveToPosition(at: indexPath, animated: false)
        }
        guard let c = context else {
            logError("Context not created")
            return
        }
        sendNavigationEvent(ShowProductDetailsEvent(context: c, retrieveCurrentImageViewTag: nil))
    }
    
    func basketView(view: BasketView, widthForDeleteActionViewForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        logInfo("Width for delete actionview for row at index path: \(indexPath)")
        return manager.deleteActionWidth ?? 0
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("Did tap retry")
        manager.validate()
    }
    
    // MARK: - Utilities
    
    func isEmptyBasket(basket: Basket?) -> Bool {
        return basket == nil || basket!.productsByBrands.isEmpty
    }
}

extension BasketViewController: ProductAmountViewControllerDelegate {
    func productAmount(viewController: ProductAmountViewController, didChangeAmountOf product: BasketProduct) {
        logInfo("Did change amount of product \(product)")
        actionAnimator.dismissViewController(presentingViewController: self, completion: nil)
        manager.updateInBasket(product)
        if product.amount == 0 {
            logAnalyticsEvent(.CartProductDeleted(product.id))
        }
        logAnalyticsEvent(AnalyticsEventId.CartQuantityChanged(product.id))
    }
    
    func productAmountWantsDismiss(viewController: ProductAmountViewController, animated: Bool) {
        logInfo("Dismissed product amount view controller")
        actionAnimator.dismissViewController(presentingViewController: self, animated: animated)
    }
}

extension BasketViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        logInfo("Did tap on dim view")
        animator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension BasketViewController: BasketDeliveryNavigationControllerDelegate {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController, animated: Bool) {
        logInfo("Delivery wants dismiss")
        deliveryAnimator.dismissViewController(presentingViewController: self, animated: animated)
    }
}

extension BasketViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController, animated: Bool) {
        logInfo("Signing wants dismiss")
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
        logInfo("Did logged in")
        dismissViewControllerAnimated(true) { [weak self] in
            self?.goToCheckout()
        }
    }
}

extension BasketViewController: CheckoutNavigationControllerDelegate {
    func checkoutWantsGoToMainScreen(checkout: CheckoutNavigationController) {
        logInfo("Checkout wants go to main screen")
        dismissViewControllerAnimated(true, completion: nil)
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    func checkoutWantsDismiss(checkout: CheckoutNavigationController, animated: Bool) {
        logInfo("Cehckout wants to dismiss")
        dismissViewControllerAnimated(animated, completion: nil)
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
