import Foundation
import RxSwift

final class CreditCardOptionHandler: PaymentOptionHandler {
    private let api: ApiService
    private var dropInDelegateHandler: DropInViewControllerDelegateHandler?
    let paymentTypes = [PaymentType.CreditCard, PaymentType.CreditCardDe]
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
            return self.retrievePaymentNonce(with: info).subscribe { (event: Event<BTPaymentMethodNonce>) in
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
    
    private func retrievePaymentNonce(with info: PaymentInfo) -> Observable<BTPaymentMethodNonce> {
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
    
    private func handlePayment(with info: PaymentInfo, token: String, observer: AnyObserver<BTPaymentMethodNonce>) {
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
        navigationController.navigationBar.applyWhiteStyle()
        
        dropInDelegateHandler = DropInViewControllerDelegateHandler(presentedViewController:navigationController, onSucceedWithTokenization: onSucceedWithTokenization, onDidCancel: onDidCancel)
        dropInViewController.applyBlackCloseButton(target: self, action: #selector(CreditCardOptionHandler.didTapCancelPayment))
        dropInViewController.title = info.payment.name
        dropInViewController.delegate = dropInDelegateHandler
        dropInViewController.theme = DropInTheme()
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
        removePayPalButton(fromSubviews: viewController.view.subviews, backgroundColor: viewController.theme?.viewBackgroundColor() ?? BTUI.braintreeTheme().viewBackgroundColor())
    }
    
    @objc func dropInViewControllerWillComplete(viewController: BTDropInViewController) {
        logInfo("Drop in will complete")
    }
    
    private func removePayPalButton(fromSubviews subviews: [UIView], backgroundColor: UIColor) {
        for view in subviews {
            if view is BTPaymentButton {
                view.hidden = true
                view.alpha = 0.0
                let whiteView = UIView()
                whiteView.backgroundColor = backgroundColor
                view.insertSubview(whiteView, atIndex: 0)
                whiteView.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                whiteView.layer.zPosition = 1
            }
            removePayPalButton(fromSubviews: view.subviews, backgroundColor: backgroundColor)
        }
    }
}

private final class DropInTheme: BTUI {
    override func idealGray() -> UIColor! { return UIColor(named: .Black) }
    override func viewBackgroundColor() -> UIColor! { return UIColor(named: .White) }
    override func disabledButtonColor() -> UIColor! { return UIColor(named: .DarkGray) }
    override func titleColor() -> UIColor! { return UIColor(named: .Black) }
    override func detailColor() -> UIColor! { return UIColor(named: .Black) }
    override func textFieldTextColor() -> UIColor! { return UIColor(named: .Black) }
    override func textFieldPlaceholderColor() -> UIColor! { return UIColor(named: .DarkGray) }
    override func sectionHeaderTextColor() -> UIColor! { return UIColor(named: .Black) }
    override func controlFont() -> UIFont! { return UIFont(fontType: .Bold) }
    override func sectionHeaderFont() -> UIFont! { return UIFont.latoBold(ofSize: 16) }
    override func horizontalMargin() -> CGFloat { return Dimensions.defaultMargin }
}
