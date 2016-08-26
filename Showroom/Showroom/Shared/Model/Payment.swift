import Foundation
import Decodable

struct PaymentRequest {
    let items: [PaymentItem]
    let countryCode: String
    let deliveryType: ObjectId
    let deliveryAddressId: ObjectId
    let deliveryPop: ObjectId?
    let discountCode: String?
    let payment: PaymentType
    let comments: [PaymentComment]
}

struct PaymentItem {
    let id: ObjectId
    let amount: Int
    let color: ObjectId
    let size: ObjectId
}

struct PaymentComment {
    let storeId: ObjectId
    let text: String
}

struct PaymentResult {
    let orderId: ObjectId
    let description: String?
    let amount: NSDecimalNumber
    let taxAmount: NSDecimalNumber
    let shippingAmount: NSDecimalNumber
    let currency: String
    let notifyUrl: String?
    let orderUrl: String
}

//MARK:- Utiliteies

extension PaymentRequest {
    init?(with checkoutState: CheckoutState) {
        guard checkoutState.checkout.deliveryCarrier.id != .Unknown && checkoutState.selectedPayment.id != .Unknown else {
            logError("Cannot create PaymentRequest (carrier, selectedPayment) from state: \(checkoutState)")
            return nil
        }
        
        var items: [PaymentItem] = []
        for productByBrands in checkoutState.checkout.basket.productsByBrands {
            items.appendContentsOf(productByBrands.products.map{ PaymentItem(with: $0) })
        }
        var comments: [PaymentComment] = []
        for (index, comment) in checkoutState.comments.enumerate() {
            if let comment = comment {
                let productByBrand = checkoutState.checkout.basket.productsByBrands[index]
                comments.append(PaymentComment(storeId: productByBrand.id, text: comment))
            }
        }
        
        let deliveryPop = checkoutState.selectedKiosk?.id
        if deliveryPop == nil && checkoutState.checkout.deliveryCarrier.id == .RUCH {
            logError("Cannot create PaymentRequest (deliveryPop) from state: \(checkoutState)")
            return nil
        }
        
        guard let selectedAddress = checkoutState.selectedAddress else {
            logError("Cannot create PaymentRequest (deliveryAddressId) from state: \(checkoutState)")
            return nil
        }
        
        self.items = items
        self.countryCode = checkoutState.checkout.deliveryCountry.id
        self.deliveryType = checkoutState.checkout.deliveryCarrier.id.rawValue
        self.deliveryAddressId = selectedAddress.id
        self.deliveryPop = deliveryPop
        self.discountCode = checkoutState.checkout.discountCode
        self.payment = checkoutState.selectedPayment.id
        self.comments = comments
    }
}

extension PaymentItem {
    init(with basketProduct: BasketProduct) {
        self.id = basketProduct.id
        self.amount = basketProduct.amount
        self.color = basketProduct.color.id
        self.size = basketProduct.size.id
    }
}

//MARK:- Encodable, Decodable

extension PaymentRequest: Encodable {
    func encode() -> AnyObject {
        let dict = [
            "items": items.map { $0.encode() } as NSArray,
            "country_code": countryCode,
            "delivery_type": deliveryType,
            "payment": payment.rawValue,
            "comments": comments.map { $0.encode() } as NSArray
        ] as NSMutableDictionary
        
        if deliveryPop != nil { dict.setObject(deliveryPop!, forKey: "delivery_pop") }
        if discountCode != nil { dict.setObject(discountCode!, forKey: "discount_code") }
        return dict
    }
}

extension PaymentItem: Encodable {
    func encode() -> AnyObject {
        return [
            "id": id,
            "amount": amount,
            "color": color,
            "size": size
        ] as NSDictionary
    }
}

extension PaymentComment: Encodable {
    func encode() -> AnyObject {
        return [
            "storeId": storeId,
            "text": text
        ]
    }
}

extension PaymentResult: Decodable {
    static func decode(json: AnyObject) throws -> PaymentResult {
        let amount: UInt64 = try json => "amount"
        let taxAmount: UInt64 = try json => "taxAmount"
        let shippingAmount: UInt64 = try json => "shippingAmount"
        return try PaymentResult(
            orderId: json => "orderId",
            description: json =>? "paymentDescription",
            amount: NSDecimalNumber(mantissa: amount, exponent: -2, isNegative: false),
            taxAmount: NSDecimalNumber(mantissa: taxAmount, exponent: -2, isNegative: false),
            shippingAmount: NSDecimalNumber(mantissa: shippingAmount, exponent: -2, isNegative: false),
            currency: json => "currency",
            notifyUrl: json =>? "notifyUrl",
            orderUrl: json => "orderUrl"
        )
    }
}