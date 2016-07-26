import Foundation
import RxSwift

class CheckoutModel {
    private let userManager: UserManager
    private let payUManager: PayUManager
    let state: CheckoutState
    weak var payUDelegate: PUPaymentServiceDelegate? {
        set { payUManager.serviceDelegate = newValue }
        get { return payUManager.serviceDelegate }
    }
    
    init(with checkout: Checkout, and userManager: UserManager, and payUManager: PayUManager) {
        self.userManager = userManager
        self.payUManager = payUManager
        
        let comments = [String?](count: checkout.basket.productsByBrands.count, repeatedValue: nil)
        let userAddresses = checkout.user.userAddresses
        state = CheckoutState(checkout: checkout, comments: comments, selectedAddress: userAddresses.first, userAddresses: userAddresses)
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
        return comments.count > index ? comments[index] : nil
    }
    
    func payUButton(withFrame frame: CGRect) -> UIView {
        return payUManager.paymentButton(withFrame: frame)
    }
}

final class CheckoutState {
    let selectedKioskObservable: Observable<Kiosk?> = PublishSubject()
    let userAddressesObservable: Observable<[UserAddress]> = PublishSubject()
    
    let checkout: Checkout
    var comments: [String?]
    var selectedKiosk: Kiosk? = nil {
        didSet {
            (selectedKioskObservable as! PublishSubject).onNext(selectedKiosk)
        }
    }
    var selectedAddress: UserAddress?
    var userAddresses: [UserAddress] {
        didSet {
            (userAddressesObservable as! PublishSubject).onNext(userAddresses)
        }
    }
    var addressAdded = false
    
    init(checkout: Checkout, comments: [String?], selectedAddress: UserAddress?, userAddresses: [UserAddress]) {
        self.checkout = checkout
        self.comments = comments
        self.selectedAddress = selectedAddress
        self.userAddresses = userAddresses
    }
}