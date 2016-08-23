import Foundation

struct ShowPaymentFailureEvent: NavigationEvent {
    let orderId: ObjectId
    let orderUrl: String
}