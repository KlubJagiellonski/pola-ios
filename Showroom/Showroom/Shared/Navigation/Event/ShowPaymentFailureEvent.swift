import Foundation

struct ShowPaymentFailureEvent: NavigationEvent {
    let orderId: String
    let orderUrl: String
}