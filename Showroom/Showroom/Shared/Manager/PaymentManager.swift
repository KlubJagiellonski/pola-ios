import Foundation

final class PaymentManager {
    private let api: ApiService
    private(set) var currentPaymentHandler: PaymentHandler? = nil
    
    init(api: ApiService) {
        self.api = api
    }
    
    func initializePaymentHandler(with payments: [Payment]) {
        logInfo("Initializing payment handler")
        currentPaymentHandler = PaymentHandler(payments: payments, api: api)
    }
    
    func invalidatePaymentHandler() {
        logInfo("Invalidating payment handler")
        currentPaymentHandler = nil
    }
}