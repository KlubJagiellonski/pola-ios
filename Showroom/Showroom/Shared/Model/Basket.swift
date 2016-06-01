import Foundation

struct Basket {
    let productsBySellers: [BasketSeller]
    let discountCode: String?
    let totalPrice: Money
}

struct BasketSeller {
    let name: String
    let products: [BasketProduct]
}

struct BasketProduct {
    let name: String
    let imageUrl: String?
    let size: String?
    let color: String?
    let price: Money
    let amount: Int
}