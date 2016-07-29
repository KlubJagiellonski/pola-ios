import Foundation
import RxSwift

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

class CheckoutModel {
    private let disposeBag = DisposeBag()
    private let userManager: UserManager
    private let payUManager: PayUManager
    private let api: ApiService
    let state: CheckoutState
    weak var payUDelegate: PUPaymentServiceDelegate? {
        set { payUManager.serviceDelegate = newValue }
        get { return payUManager.serviceDelegate }
    }
    
    init(with checkout: Checkout, and userManager: UserManager, and payUManager: PayUManager, and api: ApiService) {
        self.userManager = userManager
        self.payUManager = payUManager
        self.api = api
        
        let comments = [String?](count: checkout.basket.productsByBrands.count, repeatedValue: nil)
        let userAddresses = checkout.user.userAddresses
        let selectedPayment = checkout.defaultPayment
        let buyButtonEnabled = selectedPayment.id.isBuyButtonEnabled(with: payUManager)
        state = CheckoutState(checkout: checkout, comments: comments, selectedAddress: userAddresses.first, userAddresses: userAddresses, selectedPayment: selectedPayment, buyButtonEnabled: buyButtonEnabled)
    }
    
    func update(comment comment: String?, at index: Int) {
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
    
    func payUButton(withFrame frame: CGRect) -> UIView {
        return payUManager.paymentButton(withFrame: frame)
    }
    
    func update(withSelected kiosk: Kiosk) -> Observable<Void> {
        return api.validateBasket(with: BasketRequest(from: state.checkout, deliveryPop: kiosk.id))
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] basket in
                guard let `self` = self else { return }
                self.state.checkout.basket = basket
                self.state.selectedKiosk = kiosk
                self.updateSelectedPaymentForDefault()
        }.flatMap { _ in Observable.just() }
    }
    
    func updateSelectedPayment(forIndex index: Int) {
        state.selectedPayment = state.checkout.basket.payments[index]
        updateBuyButtonState()
    }
    
    func updateSelectedPaymentForDefault() {
        state.selectedPayment = state.checkout.defaultPayment
    }
    
    func updateBuyButtonState() {
        state.buyButtonEnabled.value = state.selectedPayment.id.isBuyButtonEnabled(with: payUManager)
    }
}

extension BasketRequest {
    private init(from checkout: Checkout, deliveryPop: ObjectId) {
        self.init(from: checkout.basket, countryCode: checkout.deliveryCountry.id, deliveryType: checkout.deliveryCarrier.id, discountCode: checkout.discountCode, deliveryPop: deliveryPop)
    }
}

extension PaymentType {
    func isBuyButtonEnabled(with payUManager: PayUManager) -> Bool {
        switch self {
        case .Cash:
            return true
        case .PayU:
            return payUManager.currentPaymentMethod != nil
        case .Gratis:
            return true
        default:
            return false
        }
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
    
    init(checkout: Checkout, comments: [String?], selectedAddress: UserAddress?, userAddresses: [UserAddress], selectedPayment: Payment, buyButtonEnabled: Bool) {
        self.checkout = checkout
        self.comments = comments
        self.selectedAddress = selectedAddress
        self.userAddresses = userAddresses
        self.selectedPayment = selectedPayment
        self.buyButtonEnabled = Variable(buyButtonEnabled)
    }
}