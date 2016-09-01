import Foundation
import RxSwift

final class PayPalOptionHandler: PaymentOptionHandler {
    private let api: ApiService
    private let presentingDelegate = PayPalPresentingDelegateHandler()
    let paymentType = PaymentType.PayPal
    var isPayMethodSelected: Bool { return true }
    weak var delegate: PaymentHandlerDelegate?
    
    init(api: ApiService) {
        self.api = api
        
        presentingDelegate.handler = self
    }
    
    func createPayMethodView(frame: CGRect) -> UIView? {
        return nil
    }
    
    func makePayment(with info: PaymentInfo, createPaymentRequest: Nonce? -> Observable<PaymentResult>) -> Observable<PaymentResult> {
        return Observable.create { [unowned self] observer in
            return self.retrievePaymentNonce(with: info).subscribe { (event: Event<Nonce>) in
                switch event {
                case .Next(let nonce):
                    createPaymentRequest(nonce).subscribe(observer)
                case .Error(let error):
                    observer.onError(error)
                default: break
                }
            }
        }
    }
    
    private func retrievePaymentNonce(with info: PaymentInfo) -> Observable<Nonce> {
        return Observable.create { [unowned self] observer in
            return self.api.authorizePayment(withProvider: .Braintree)
                .observeOn(MainScheduler.instance)
                .subscribe { (event: Event<PaymentAuthorizeResult>) in
                    switch event {
                    case .Next(let result):
                        logInfo("Success in fetching Braintree token")
                        self.handlePayment(with: info, token: result.accessToken, observer: observer)
                    case .Error(let error):
                        logInfo("Error during fetching Braintree token \(error)")
                        observer.onError(PaymentHandlerError.BrainTreeFetchingTokenError(error))
                    default: break
                    }
            }
        }
    }
    
    private func handlePayment(with info: PaymentInfo, token: String, observer: AnyObserver<Nonce>) {
        guard let braintreeClient = BTAPIClient(authorization: token) else {
            observer.onError(PaymentHandlerError.BrainTreeCreatingClientError)
            return
        }
        
        let payPalDriver = BTPayPalDriver(APIClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = presentingDelegate
        
        let payPalRequest = BTPayPalRequest(amount: info.amount)
        payPalRequest.currencyCode = info.currencyCode
        payPalRequest.localeCode = info.localeCode
        payPalDriver.requestOneTimePayment(payPalRequest) { (nonce, error) -> Void in
            guard let nonce = nonce else {
                if let error = error {
                    logInfo("Received braintree error \(error)")
                    observer.onError(PaymentHandlerError.BrainTreeError(error))
                } else {
                    logInfo("Received braintree cancelled")
                    observer.onError(PaymentHandlerError.BrainTreeCancelled)
                }
                return
            }
            logInfo("Received nonce: \(nonce.nonce)")
            observer.onNext(nonce.nonce)
            observer.onCompleted()
        }
    }
    
    func handleOpenURL(url: NSURL, sourceApplication: String?) -> Bool {
        if url.scheme.localizedCaseInsensitiveCompare(Constants.braintreePayPalUrlScheme) == .OrderedSame {
            return BTAppSwitch.handleOpenURL(url, sourceApplication:sourceApplication)
        }
        return false
    }
}

private class PayPalPresentingDelegateHandler: NSObject, BTViewControllerPresentingDelegate {
    private weak var handler: PayPalOptionHandler?
    
    @objc func paymentDriver(driver: AnyObject, requestsPresentationOfViewController viewController: UIViewController) {
        handler?.delegate?.paymentHandlerWantsPresentViewController(viewController)
    }
    
    @objc func paymentDriver(driver: AnyObject, requestsDismissalOfViewController viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
