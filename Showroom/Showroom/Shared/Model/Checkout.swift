import Foundation

struct Checkout {
    let basket: Basket
    let deliveryCarrier: DeliveryCarrier
    let deliveryCountry: DeliveryCountry
    let discountCode: String?
}

extension Checkout {
    static func from(basketState basketState: BasketState) -> Checkout? {
        guard let basket = basketState.basket, let carrier = basketState.deliveryCarrier, let country = basketState.deliveryCountry else { return nil }
        return Checkout(
            basket: basket,
            deliveryCarrier: carrier,
            deliveryCountry: country,
            discountCode: basketState.discountCode
        )
    }
}