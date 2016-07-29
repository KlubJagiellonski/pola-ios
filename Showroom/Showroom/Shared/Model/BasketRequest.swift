import Foundation
import UIKit

struct BasketRequest {
    let items: [BasketItem]
    let countryCode: String?
    let deliveryType: DeliveryType?
    let discountCode: String?
    let deliveryPop: ObjectId?
}

struct BasketItem {
    let id: ObjectId
    let amount: Int
    let color: ObjectId
    let size: ObjectId
}

extension BasketRequest {
    init(from basket: Basket?, countryCode: String?, deliveryType: DeliveryType?, discountCode: String?, deliveryPop: ObjectId?) {
        var items: [BasketItem] = []
        if let basket = basket {
            for brand in basket.productsByBrands {
                for product in brand.products {
                    let item = BasketItem(id: product.id, amount: product.amount, color: product.color.id, size: product.size.id)
                    items.append(item)
                }
                
            }
        }
        self.items = items
        self.countryCode = countryCode
        self.deliveryType = deliveryType
        self.discountCode = discountCode
        self.deliveryPop = deliveryPop
    }
}

//MARK:- Encodable

extension BasketRequest: Encodable {
    func encode() -> AnyObject {
        let itemsArray: NSMutableArray = []
        for item in items {
            itemsArray.addObject(item.encode())
        }
        
        let dict: NSMutableDictionary = [
            "items": itemsArray,
        ]
        
        if countryCode != nil { dict.setObject(countryCode!, forKey: "country_code") }
        if deliveryType != nil { dict.setObject(deliveryType!.rawValue, forKey: "delivery_type") }
        if discountCode != nil { dict.setObject(discountCode!, forKey: "discount_code") }
        if deliveryPop != nil { dict.setObject(deliveryPop!, forKey: "delivery_pop") }
        return dict
    }
}

extension BasketItem: Encodable {
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "amount": amount,
            "color": color,
            "size": size
        ]
        return dict
    }
}