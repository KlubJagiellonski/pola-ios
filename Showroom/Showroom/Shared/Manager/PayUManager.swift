import Foundation
import RxSwift

enum PayUPaymentError: ErrorType {
    case InvalidRequest
    case UserWantsRetry
    case Cancelled
}

final class PayUManager {
    private let disposeBag = DisposeBag()
    private let dataSource = PayUAuthorizationDataSource()
    private let delegate = PayUPaymentServiceDelegate()
    private let api: ApiService
    private let userManager: UserManager
    private let paymentService = PUPaymentService()
    weak var serviceDelegate: PUPaymentServiceDelegate? {
        set { delegate.delegate = newValue }
        get { return delegate.delegate }
    }
    var currentPaymentMethod: PUPaymentMethodDescription? {
        return delegate.paymentMethodDescription
    }
    
    init(api: ApiService, userManager: UserManager) {
        self.api = api
        self.userManager = userManager
        
        dataSource.manager = self
        paymentService.dataSource = dataSource
        paymentService.delegate = delegate
        
        userManager.sessionObservable.subscribeNext { [weak self] session in
            if session == nil {
                self?.delegate.paymentMethodDescription = nil
                self?.paymentService.clearUserContext()
            }
        }.addDisposableTo(disposeBag)
    }
    
    private func fetchPayUToken() -> Observable<PaymentAuthorizeResult> {
        return api.authorizePayment(withProvider: .PayU)
    }
    
    func paymentButton(withFrame frame: CGRect) -> UIView {
        return paymentService.paymentMethodWidgetWithFrame(frame)
    }
    
    func handleOpen(withURL url: NSURL) -> Bool {
        return paymentService.handleOpenURL(url)
    }
    
    func makePayment(with paymentResult: PaymentResult) -> Observable<PaymentResult> {
        guard let description = paymentResult.description, let url = paymentResult.notifyUrl, let notifyUrl = NSURL(string: url) else {
            logError("Cannot make payment with result \(paymentResult)")
            return Observable.error(PayUPaymentError.InvalidRequest)
        }
        
        let request = PUPaymentRequest()
        request.extOrderId = String(paymentResult.orderId)
        request.amount = paymentResult.amount
        request.currency = paymentResult.currency
        request.paymentDescription = description
        request.notifyURL = notifyUrl
        
        return Observable.create { [unowned self] observer in
            self.paymentService.submitPaymentRequest(request) { result in
                switch result.status {
                case .Success:
                    observer.onNext(paymentResult)
                    observer.onCompleted()
                case .Failure:
                    observer.onError(PayUPaymentError.Cancelled)
                    observer.onCompleted()
                case .Retry:
                    observer.onError(PayUPaymentError.UserWantsRetry)
                    observer.onCompleted()
                }
            }
            return NopDisposable.instance
        }
    }
}

final class PayUAuthorizationDataSource: NSObject, PUAuthorizationDataSource {
    private let disposeBag = DisposeBag()
    private weak var manager: PayUManager?
    
    func refreshTokenWithCompletionHandler(completionHandler: ((String!, NSError!) -> Void)!) {
        guard let manager = manager else {
            logError("manager should not be nil")
            completionHandler(nil, NSError(domain: "PayUManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Manager is nil"]))
            return
        }
        
        guard manager.userManager.session != nil else {
            logError("Cannot refresh PayU token when session is nil")
            completionHandler(nil, NSError(domain: "PayUManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No session"]))
            return
        }
        
        manager.fetchPayUToken().subscribe { (event: Event<PaymentAuthorizeResult>) in
            switch event {
            case .Next(let result):
                logInfo("Success in fetching PayU token")
                completionHandler(result.accessToken, nil)
            case .Error(let error):
                logInfo("Error during fetching PayU token \(error)")
                completionHandler(nil, NSError(domain: "PayUManager", code: 402, userInfo: [NSLocalizedDescriptionKey: String(error)]))
            default: break
            }
        }.addDisposableTo(disposeBag)
    }
    
    func applicationCallbackScheme() -> String! {
        return Constants.appScheme
    }
}

final class PayUPaymentServiceDelegate: NSObject, PUPaymentServiceDelegate {
    private weak var delegate: PUPaymentServiceDelegate?
    private var paymentMethodDescription: PUPaymentMethodDescription?
    
    func paymentServiceDidSelectPaymentMethod(paymentMethod: PUPaymentMethodDescription!) {
        paymentMethodDescription = paymentMethod
        guard let delegate = delegate else {
            logError("No delegate assigned with selected payment method: \(paymentMethod)")
            return
        }
        delegate.paymentServiceDidSelectPaymentMethod?(paymentMethod)
    }
    
    func paymentServiceDidRequestPresentingViewController(viewController: UIViewController!) {
        guard let delegate = delegate else {
            logError("No delegate assigned with request presenting view controller: \(viewController)")
            return
        }
        delegate.paymentServiceDidRequestPresentingViewController(viewController)
    }
}