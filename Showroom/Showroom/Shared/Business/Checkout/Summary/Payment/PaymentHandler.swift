import Foundation
import RxSwift

typealias Nonce = String

enum PaymentHandlerError: ErrorType {
    case NoPaymentHandler
    case CannotCreatePayment
    case PaymentRequestFailed(ErrorType)
    case PayUInvalidRequest(PaymentResult)
    case PayUUserWantsRetry(PaymentResult)
    case PayUCancelled(PaymentResult)
    case BrainTreeFetchingTokenError(ErrorType)
    case BrainTreeError(NSError)
    case BrainTreeCreatingClientError
    case BrainTreeCancelled
}

protocol PaymentHandlerDelegate: class {
    func paymentHandlerWantsPresentViewController(viewController: UIViewController)
    func paymentHandlerDidChange()
}

protocol PaymentOptionHandler: class {
    var paymentType: PaymentType { get }
    weak var delegate: PaymentHandlerDelegate? { set get }
    var isPayMethodSelected: Bool { get } //for enabling disabling buy button
    
    func makePayment(with info: PaymentInfo, createPaymentRequest: Nonce? -> Observable<PaymentResult>) -> Observable<PaymentResult>
    func createPayMethodView(frame: CGRect) -> UIView?
    func handleOpenURL(url: NSURL, sourceApplication: String?) -> Bool
}

final class PaymentHandler {
    private let handlers: [PaymentOptionHandler]
    private let api: ApiService
    weak var delegate: PaymentHandlerDelegate? {
        didSet {
            for handler in handlers {
                handler.delegate = delegate
            }
        }
    }
    
    init(payments: [Payment], api: ApiService) {
        var handlers: [PaymentOptionHandler] = []
        for payment in payments {
            switch payment.id {
            case .Cash: handlers.append(CashOptionHandler())
            case .CreditCard: handlers.append(CreditCardOptionHandler(api: api))
            case .Gratis: handlers.append(GratisOptionHandler())
            case .PayPal: handlers.append(PayPalOptionHandler(api: api))
            case .PayU: handlers.append(PayUOptionHandler(api: api))
            case .Unknown:
                logError("Cannot create payment handler for unknown payment type")
                continue
            }
        }
        self.handlers = handlers
        self.api = api
    }
    
    func createPayMethodView(frame: CGRect, forType type: PaymentType) -> UIView? {
        guard let handler = handlers.find({ $0.paymentType == type }) else {
            logError("Cannot find handler for type \(type), handlers \(handlers)")
            return nil
        }
        return handler.createPayMethodView(frame)
    }
    
    func makePayment(forPaymentType type: PaymentType, info: PaymentInfo) -> Observable<PaymentResult> {
        guard let handler = handlers.find({ $0.paymentType == type }) else {
            logError("Cannot retrieve handler for type \(type), handlers \(handlers)")
            return Observable.error(PaymentHandlerError.NoPaymentHandler)
        }
        return handler.makePayment(with: info) { [weak self] nonce in
            guard let `self` = self else {
                return Observable.error(PaymentHandlerError.CannotCreatePayment)
            }
            // TODO: add nonce to api call
            return self.api.createPayment(with: PaymentRequest(with: info)).catchError {
                Observable.error(PaymentHandlerError.PaymentRequestFailed($0))
            }
        }
    }
    
    func isPayMethodSelected(forType type: PaymentType) -> Bool {
        guard let handler = handlers.find({ $0.paymentType == type }) else {
            logError("Cannot retrieve handler for type \(type), handlers \(handlers)")
            return false
        }
        return handler.isPayMethodSelected
    }
    
    func handleOpenURL(url: NSURL, sourceApplication: String?) -> Bool {
        var handled = false
        for handler in handlers {
            if handler.handleOpenURL(url, sourceApplication: sourceApplication) {
                handled = true
            }
        }
        return handled
    }
}