import Foundation

struct Basket {
    let productsBySellers: [BasketBrand]
    let discountCode: String?
    let totalPrice: Money
}

struct BasketBrand {
    let name: String
    let products: [BasketProduct]
}

struct BasketProduct {
    let name: String
    let imageUrl: String?
    let size: String?
    let color: String?
    let price: Money
    let discountPrice: Money?
    let amount: Int
}