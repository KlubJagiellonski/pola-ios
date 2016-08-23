import Foundation

struct ShowPaymentSuccessEvent: NavigationEvent {
    let orderId: ObjectId
    let orderUrl: String
}