import Foundation
import RxSwift

final class CreditCardOptionHandler: PaymentOptionHandler {
    private let api: ApiService
    private var dropInDelegateHandler: DropInViewControllerDelegateHandler?
    let paymentType = PaymentType.CreditCard
    weak var delegate: PaymentHandlerDelegate?
    var isPayMethodSelected: Bool {
        return true
    }
    
    init(api: ApiService) {
        self.api = api
    }
    
    func createPayMethodView(frame: CGRect) -> UIView? {
        return nil
    }
    
    func makePayment(with info: PaymentInfo, createPaymentRequest: Nonce? -> Observable<PaymentResult>) -> Observable<PaymentResult> {
        return Observable.create { [unowned self] observer in
            return self.retrievePaymentNonce().subscribe { (event: Event<BTPaymentMethodNonce>) in
                switch event {
                case .Next(let nonce):
                    createPaymentRequest(nonce.nonce).subscribe(observer)
                case .Error(let error):
                    observer.onError(error)
                default: break
                }
            }
        }
    }
    
    func handleOpenURL(url: NSURL, sourceApplication: String?) -> Bool {
        return false
    }
    
    private func retrievePaymentNonce() -> Observable<BTPaymentMethodNonce> {
        return Observable.create { [unowned self] observer in
            return self.api.authorizePayment(withProvider: .Braintree)
                .observeOn(MainScheduler.instance)
                .subscribe { (event: Event<PaymentAuthorizeResult>) in
                    switch event {
                    case .Next(let result):
                        logInfo("Success in fetching Braintree token")
                        self.handlePayment(withToken: result.accessToken, observer: observer)
                    case .Error(let error):
                        logInfo("Error during fetching Braintree token \(error)")
                        let clientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiIwODRlZWI1MGZjNGU5YjBlNTNhZWZlNDlmMGMzNWJkNDZlYTFlY2IyYzFjMmIzYzg1MTFmNWM2Y2YzZGE5OTlifGNyZWF0ZWRfYXQ9MjAxNi0wOS0xMlQxNTowOTo0Ny42NzE5NTgzNjIrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0="
                        self.handlePayment(withToken: clientToken, observer: observer)
                    //                    observer.onError(BraintreeError.FetchingTokenError(error))
                    default: break
                    }
            }
        }
    }
    
    private func handlePayment(withToken token: String, observer: AnyObserver<BTPaymentMethodNonce>) {
        guard let braintreeClient = BTAPIClient(authorization: token) else {
            logError("Cannot create client for token \(token)")
            observer.onError(PaymentHandlerError.BrainTreeCreatingClientError)
            return
        }
        
        let onSucceedWithTokenization: BTPaymentMethodNonce -> Void = { [weak self] nonce in
            guard let `self` = self else { return }
            self.dropInDelegateHandler = nil
            
            observer.onNext(nonce)
            observer.onCompleted()
        }
        
        let onDidCancel: Void -> Void = { [weak self] in
            guard let `self` = self else { return }
            
            self.dropInDelegateHandler?.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
            self.dropInDelegateHandler = nil
            
            observer.onError(PaymentHandlerError.BrainTreeCancelled)
        }
        
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient)
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        
        dropInDelegateHandler = DropInViewControllerDelegateHandler(presentedViewController:navigationController, onSucceedWithTokenization: onSucceedWithTokenization, onDidCancel: onDidCancel)
        dropInViewController.delegate = dropInDelegateHandler
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreditCardOptionHandler.didTapCancelPayment))
        delegate?.paymentHandlerWantsPresentViewController(navigationController)
    }
    
    @objc private func didTapCancelPayment() {
        self.dropInDelegateHandler?.onDidCancel()
    }

}

final private class DropInViewControllerDelegateHandler: NSObject, BTDropInViewControllerDelegate {
    private weak var presentedViewController: UIViewController?
    private var onSucceedWithTokenization: BTPaymentMethodNonce -> Void
    private var onDidCancel: Void -> Void
    
    init(presentedViewController: UIViewController, onSucceedWithTokenization: BTPaymentMethodNonce -> Void, onDidCancel: Void -> Void) {
        self.presentedViewController = presentedViewController
        self.onSucceedWithTokenization = onSucceedWithTokenization
        self.onDidCancel = onDidCancel
        super.init()
    }
    
    @objc func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        logInfo("Drop in did succeed with tokenization \(paymentMethodNonce.type)")
        onSucceedWithTokenization(paymentMethodNonce)
    }
    
    @objc func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        logInfo("Drop in did cancel")
        onDidCancel()
    }
    
    @objc func dropInViewControllerDidLoad(viewController: BTDropInViewController) {
        logInfo("Drop in did load")
    }
    
    @objc func dropInViewControllerWillComplete(viewController: BTDropInViewController) {
        logInfo("Drop in will complete")
    }
}
