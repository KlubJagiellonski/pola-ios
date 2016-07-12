import Foundation

struct Checkout {
    let basket: Basket
    let user: User
    let deliveryCarrier: DeliveryCarrier
    let deliveryCountry: DeliveryCountry
    let discountCode: String?
}

extension Checkout {
    static func from(basketState basketState: BasketState, user: User) -> Checkout? {
        guard let basket = basketState.basket, let carrier = basketState.deliveryCarrier, let country = basketState.deliveryCountry else { return nil }
        return Checkout(
            basket: basket,
            user: user,
            deliveryCarrier: carrier,
            deliveryCountry: country,
            discountCode: basketState.discountCode
        )
    }
}