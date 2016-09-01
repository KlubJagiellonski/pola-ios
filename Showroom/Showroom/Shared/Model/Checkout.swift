import Foundation
import Decodable

struct Checkout {
    var basket: Basket
    let user: User
    let deliveryCarrier: DeliveryCarrier
    let deliveryCountry: DeliveryCountry
    let discountCode: String?
}

enum PaymentAuthorizeProvider: String {
    case PayU = "payu"
    case Braintree = "braintree"
}

struct PaymentAuthorizeResult {
    let accessToken: String
}

// MARK:- Utilities

extension Checkout {
    static func from(basketState basketState: BasketState, user: User) -> Checkout? {
        guard let basket = basketState.basket, let carrier = basketState.deliveryCarrier, let country = basketState.deliveryCountry else {
            logInfo("Cannot create checkout for state \(basketState)")
            return nil
        }
        return Checkout(
            basket: basket,
            user: user,
            deliveryCarrier: carrier,
            deliveryCountry: country,
            discountCode: basketState.discountCode
        )
    }
}

// MARK:- Decodable

extension PaymentAuthorizeResult: Decodable {
    static func decode(json: AnyObject) throws -> PaymentAuthorizeResult {
        return try PaymentAuthorizeResult(
            accessToken: json => "access_token"
        )
    }
}