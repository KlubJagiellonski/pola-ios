import Foundation
import RxSwift
import RxCocoa

extension Checkout {
    var defaultPayment: Payment {
        var defaultPayment = basket.payments.find { $0.isDefault }
        if defaultPayment == nil {
            defaultPayment = basket.payments.first
        }
        guard let payment = defaultPayment else {
            fatalError("Cannot retrieve default payment for checkout: \(self)")
        }
        return payment
    }
}

final class CheckoutModel {
    private let disposeBag = DisposeBag()
    private let userManager: UserManager
    private let basketManager: BasketManager
    private let platformManager: PlatformManager
    private let paymentManager: PaymentManager
    private let api: ApiService
    private let emarsysService: EmarsysService
    let state: CheckoutState
    weak var paymentDelegate: PaymentHandlerDelegate? {
        set { paymentManager.currentPaymentHandler?.delegate = newValue }
        get { return paymentManager.currentPaymentHandler?.delegate }
    }
    
    init(with checkout: Checkout, userManager: UserManager, platformManager: PlatformManager, paymentManager: PaymentManager, api: ApiService, basketManager: BasketManager, emarsysService: EmarsysService) {
        self.userManager = userManager
        self.platformManager = platformManager
        self.paymentManager = paymentManager
        self.api = api
        self.basketManager = basketManager
        self.emarsysService = emarsysService
        
        let comments = [String?](count: checkout.basket.productsByBrands.count, repeatedValue: nil)
        let userAddresses = checkout.user.userAddresses
        let selectedPayment = checkout.defaultPayment
        state = CheckoutState(checkout: checkout, comments: comments, selectedAddress: userAddresses.first, userAddresses: userAddresses, selectedPayment: selectedPayment, buyButtonEnabled: false)
    }
    
    func update(comment comment: String?, at index: Int) {
        logInfo("Update comment: \(comment) at index: \(index)")
        if index < 0 || index >= state.comments.count {
            return
        }
        
        guard let comment = comment else {
            state.comments[index] = nil
            return
        }
        
        let trimmedComment = comment.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedComment.characters.count == 0 {
            state.comments[index] = nil
            return
        }
        
        state.comments[index] = comment
    }
    
    func comment(at index: Int) -> String? {
        let comments = state.comments
        return comments.count > index ? comments[index]: nil
    }
    
    func payUButton(withFrame frame: CGRect) -> UIView? {
        return paymentManager.currentPaymentHandler?.createPayMethodView(frame, forType: .PayU)
    }
    
    func update(withSelected kiosk: Kiosk) -> Observable<Void> {
        return api.validateBasket(with: BasketRequest(from: state.checkout, deliveryPop: kiosk.id))
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] basket in
                guard let `self` = self else { return }
                logInfo("Update with selected kiosk: \(kiosk) on basket changed: \(basket)")
                self.state.checkout.basket = basket
                self.state.selectedKiosk = kiosk
                self.updateSelectedPaymentForDefault()
        }.flatMap { _ in Observable.just() }
    }
    
    func updateSelectedPayment(forType type: PaymentType) {
        logInfo("Update selected payment for type: \(type)")
        guard let selectedPayment = state.checkout.basket.payments.find({ $0.id == type }) else {
            logError("Cannot retrieve payment with id \(type) from payments \(state.checkout.basket.payments)")
            return
        }
        state.selectedPayment = selectedPayment
        updateBuyButtonState()
    }
    
    func updateSelectedPaymentForDefault() {
        logInfo("Update selected payment for default")
        state.selectedPayment = state.checkout.defaultPayment
    }
    
    func updateBuyButtonState() {
        state.buyButtonEnabled.value = paymentManager.currentPaymentHandler?.isPayMethodSelected(forType: state.selectedPayment.id) ?? false
    }
    
    func update(with userAddress: EditUserAddress) -> Observable<UserAddress> {
        let newUserAddress = userAddress.addressWithChanging(country: state.checkout.deliveryCountry.id)
        
        var result: Observable<UserAddress>!
        if let currentUserAddress = state.userAddresses.last where state.addressAdded {
            result = api.editUserAddress(forId: currentUserAddress.id, address: newUserAddress)
        } else {
            result = api.addUserAddress(newUserAddress)
        }
        return result
            .catchError { error in
                guard let urlError = error as? RxCocoaURLError else { return Observable.error(EditAddressError.Unknown(error)) }
                guard case let .HTTPRequestFailed(response, data) = urlError where response.statusCode == 400 else { return Observable.error(EditAddressError.Unknown(error)) }
                
                let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                logInfo("Edit address validation error data\(errorData)")
                let validtionError: EditAddressValidationError = try EditAddressValidationError.decode(errorData)
                logInfo("Edit address validation error: \(validtionError.message)")
                return Observable.error(EditAddressError.ValidationFailed(validtionError.errors))
            }
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] userAddress in
                guard let `self` = self else { return }
                logInfo("Update on user address changed: \(userAddress)")
                
                self.userManager.updateUser()
                
                if self.state.addressAdded {
                    self.state.userAddresses[self.state.userAddresses.count - 1] = userAddress
                } else {
                    self.state.addressAdded = true
                    self.state.userAddresses.append(userAddress)
                }
                self.state.selectedAddress = userAddress
            }
    }
    
    func initializePaymentHandler() {
        logInfo("Initializing payment handler")
        paymentManager.initializePaymentHandler(with: state.checkout.basket.payments)
        updateBuyButtonState()
    }
    
    func invalidatePaymentHandler() {
        logInfo("Invalidating payment handler")
        paymentManager.invalidatePaymentHandler()
    }

    
    func makePayment() -> Observable<PaymentResult> {
        guard let paymentHandler = paymentManager.currentPaymentHandler else {
            logError("No payment handler")
            return Observable.error(PaymentHandlerError.NoPaymentHandler)
        }
        guard let paymentInfo = PaymentInfo(with: state, platformManager: platformManager) else {
            logError("Cannot create payment info \(state), \(platformManager.platform)")
            return Observable.error(PaymentHandlerError.CannotCreatePayment)
        }
        return paymentHandler.makePayment(forPaymentType: state.selectedPayment.id, info: paymentInfo)
            .doOnNext { [weak self] result in
                guard let `self` = self else { return }
                self.emarsysService.sendPurchaseEvent(withOrderId: result.orderId, products: self.state.checkout.basket.products)
            }.observeOn(MainScheduler.instance)
    }
    
    func clearBasket() {
        logInfo("Clear basket")
        basketManager.clearBasket()
    }
}

extension BasketRequest {
    private init(from checkout: Checkout, deliveryPop: ObjectId) {
        self.init(from: checkout.basket, countryCode: checkout.deliveryCountry.id, deliveryType: checkout.deliveryCarrier.id, discountCode: checkout.discountCode, deliveryPop: deliveryPop)
    }
}

extension EditUserAddress {
    func addressWithChanging(country country: String) -> EditUserAddress {
        return EditUserAddress(firstName: firstName, lastName: lastName, streetAndAppartmentNumbers: streetAndAppartmentNumbers, postalCode: postalCode, city: city, country: country, phone: phone, description: description)
    }
}

final class CheckoutState {
    let selectedKioskObservable: Observable<Kiosk?> = PublishSubject()
    let userAddressesObservable: Observable<[UserAddress]> = PublishSubject()
    
    var checkout: Checkout
    var comments: [String?]
    private(set) var selectedKiosk: Kiosk? = nil {
        didSet { (selectedKioskObservable as! PublishSubject).onNext(selectedKiosk) }
    }
    var selectedAddress: UserAddress?
    var userAddresses: [UserAddress] {
        didSet { (userAddressesObservable as! PublishSubject).onNext(userAddresses) }
    }
    var addressAdded = false
    var selectedPayment: Payment
    private(set) var buyButtonEnabled: Variable<Bool>
    var editableAddress: UserAddress? {
        if addressAdded {
            return userAddresses.last
        } else {
            return nil
        }
    }
    var isFormMode: Bool {
        let isInFormEditMode = editableAddress != nil && userAddresses.count == 1
        let isInFormAddMode = userAddresses.isEmpty
        return isInFormEditMode || isInFormAddMode
    }
    
    init(checkout: Checkout, comments: [String?], selectedAddress: UserAddress?, userAddresses: [UserAddress], selectedPayment: Payment, buyButtonEnabled: Bool) {
        self.checkout = checkout
        self.comments = comments
        self.selectedAddress = selectedAddress
        self.userAddresses = userAddresses
        self.selectedPayment = selectedPayment
        self.buyButtonEnabled = Variable(buyButtonEnabled)
    }
}