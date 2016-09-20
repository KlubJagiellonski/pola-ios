import Foundation
import RxSwift

final class PayUOptionHandler: PaymentOptionHandler {
    let paymentTypes = [PaymentType.PayU, PaymentType.PayUDe]

    private let disposeBag = DisposeBag()
    private let dataSource = PayUAuthorizationDataSource()
    private let payUDelegate = PayUPaymentServiceDelegate()
    private let api: ApiService
    private let paymentService = PUPaymentService()
    weak var delegate: PaymentHandlerDelegate? {
        set { payUDelegate.handlerDelegate = newValue }
        get { return payUDelegate.handlerDelegate }
    }
    var isPayMethodSelected: Bool {
        return payUDelegate.paymentMethodDescription != nil
    }
    
    init(api: ApiService) {
        self.api = api
        
        dataSource.handler = self
        
        paymentService.dataSource = dataSource
        paymentService.delegate = payUDelegate
    }
    
    static func resetUserCache() {
        PUPaymentService().clearUserContext()
    }
    
    func createPayMethodView(frame: CGRect) -> UIView? {
        logInfo("Creating payment button \(frame)")
        return paymentService.paymentMethodWidgetWithFrame(frame)
    }
    
    func makePayment(with info: PaymentInfo, createPaymentRequest: Nonce? -> Observable<PaymentResult>) -> Observable<PaymentResult> {
        return Observable.create { [unowned self] observer in
            createPaymentRequest(nil).subscribe { [weak self](event: Event<PaymentResult>) in
                guard let `self` = self else { return }
                
                switch event {
                case .Next(let result):
                    self.makePayUPayment(with: result).subscribe(observer)
                case .Error(let error):
                    observer.onError(error)
                default: break
                }
            }
        }
    }
    
    func handleOpenURL(url: NSURL, sourceApplication: String?) -> Bool {
        logInfo("Handling open \(url)")
        return paymentService.handleOpenURL(url)
    }
    
    private func fetchPayUToken() -> Observable<PaymentAuthorizeResult> {
        logInfo("Fetching payu token")
        return api.authorizePayment(withProvider: .PayU)
    }
    
    private func makePayUPayment(with paymentResult: PaymentResult) -> Observable<PaymentResult> {
        guard let description = paymentResult.description, let url = paymentResult.notifyUrl, let notifyUrl = NSURL(string: url), let extOrderId = paymentResult.extOrderId else {
            logError("Cannot make payment with result \(paymentResult)")
            return Observable.error(PaymentHandlerError.PayUInvalidRequest(paymentResult))
        }
        
        logInfo("Making payment \(paymentResult)")
        
        let request = PUPaymentRequest()
        request.extOrderId = extOrderId
        request.amount = paymentResult.amount
        request.currency = paymentResult.currency
        request.paymentDescription = description
        request.notifyURL = notifyUrl
        
        return Observable.create { [unowned self] observer in
            self.paymentService.submitPaymentRequest(request) { result in
                logInfo("Received status \(result.status)")
                switch result.status {
                case .Success:
                    observer.onNext(paymentResult)
                    observer.onCompleted()
                case .Failure:
                    observer.onError(PaymentHandlerError.PayUCancelled(paymentResult))
                case .Retry:
                    observer.onError(PaymentHandlerError.PayUUserWantsRetry(paymentResult))
                }
            }
            return NopDisposable.instance
        }
    }
}

final class PayUAuthorizationDataSource: NSObject, PUAuthorizationDataSource {
    private let disposeBag = DisposeBag()
    private weak var handler: PayUOptionHandler?
    
    func refreshTokenWithCompletionHandler(completionHandler: ((String!, NSError!) -> Void)!) {
        guard let handler = handler else {
            logError("handler should not be nil")
            completionHandler(nil, NSError(domain: "PayUOptionHandler", code: 400, userInfo: [NSLocalizedDescriptionKey: "Handler is nil"]))
            return
        }
        
        handler.fetchPayUToken().subscribe { (event: Event<PaymentAuthorizeResult>) in
            switch event {
            case .Next(let result):
                logInfo("Success in fetching PayU token")
                completionHandler(result.accessToken, nil)
            case .Error(let error):
                logInfo("Error during fetching PayU token \(error)")
                completionHandler(nil, NSError(domain: "PayUOptionHandler", code: 402, userInfo: [NSLocalizedDescriptionKey: String(error)]))
            default: break
            }
            }.addDisposableTo(disposeBag)
    }
    
    func applicationCallbackScheme() -> String! {
        return Constants.appScheme
    }
}

final class PayUPaymentServiceDelegate: NSObject, PUPaymentServiceDelegate {
    private weak var handlerDelegate: PaymentHandlerDelegate?
    private var paymentMethodDescription: PUPaymentMethodDescription?
    
    func paymentServiceDidSelectPaymentMethod(paymentMethod: PUPaymentMethodDescription!) {
        logInfo("Did select payment method")
        paymentMethodDescription = paymentMethod
        guard let handlerDelegate = handlerDelegate else {
            logInfo("No delegate assigned with selected payment method: \(paymentMethod)")
            return
        }
        handlerDelegate.paymentHandlerDidChange()
    }
    
    func paymentServiceDidRequestPresentingViewController(viewController: UIViewController!) {
        logInfo("Did request presenting view controller")
        guard let handlerDelegate = handlerDelegate else {
            logInfo("No delegate assigned with request presenting view controller: \(viewController)")
            return
        }
        handlerDelegate.paymentHandlerWantsPresentViewController(viewController)
    }
}