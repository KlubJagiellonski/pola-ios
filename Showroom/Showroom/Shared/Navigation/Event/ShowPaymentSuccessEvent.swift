import Foundation

struct ShowPaymentSuccessEvent: NavigationEvent {
    let orderId: String
    let orderUrl: String
}