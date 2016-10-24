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
    let nonce: String?
}

struct PaymentInfo {
    let items: [PaymentItem]
    let countryCode: String
    let deliveryType: ObjectId
    let deliveryAddressId: ObjectId
    let deliveryPop: ObjectId?
    let discountCode: String?
    let payment: Payment
    let comments: [PaymentComment]
    let amount: String
    let currencyCode: String
    let localeCode: String
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
    let orderId: String
    let extOrderId: String?
    let description: String?
    let amount: NSDecimalNumber
    let taxAmount: NSDecimalNumber
    let shippingAmount: NSDecimalNumber
    let currency: String
    let notifyUrl: String?
    let orderUrl: String
}

//MARK:- Utiliteies

extension PaymentInfo {
    init?(with checkoutState: CheckoutState, configurationManager: ConfigurationManager) {
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
        
        guard let currencyCode = configurationManager.configuration?.currencyCode else {
            logError("Cannot create PaymentRequest (currencyCode) from state: \(checkoutState)")
            return nil
        }
        
        guard let localeCode = configurationManager.configuration?.locale.appLanguageCode else {
            logError("Cannot create PaymentRequest (localeCode) from state: \(checkoutState), configuration \(configurationManager.configuration)")
            return nil
        }
        
        self.items = items
        self.countryCode = checkoutState.checkout.deliveryCountry.id
        self.deliveryType = checkoutState.checkout.deliveryCarrier.id.rawValue
        self.deliveryAddressId = selectedAddress.id
        self.deliveryPop = deliveryPop
        self.discountCode = checkoutState.checkout.discountCode
        self.payment = checkoutState.selectedPayment
        self.comments = comments
        self.amount = checkoutState.checkout.basket.price.stringAmount
        self.currencyCode = currencyCode
        self.localeCode = localeCode
    }
}

extension PaymentRequest {
    init(with paymentInfo: PaymentInfo, nonce: String?) {
        self.items = paymentInfo.items
        self.countryCode = paymentInfo.countryCode
        self.deliveryType = paymentInfo.deliveryType
        self.deliveryAddressId = paymentInfo.deliveryAddressId
        self.deliveryPop = paymentInfo.deliveryPop
        self.discountCode = paymentInfo.discountCode
        self.payment = paymentInfo.payment.id
        self.comments = paymentInfo.comments
        self.nonce = nonce
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
            "delivery_address_id": deliveryAddressId,
            "payment_type": payment.rawValue,
            "comments": comments.map { $0.encode() } as NSArray
        ] as NSMutableDictionary
        
        if deliveryPop != nil { dict.setObject(deliveryPop!, forKey: "delivery_pop") }
        if discountCode != nil { dict.setObject(discountCode!, forKey: "discount_code") }
        if nonce != nil { dict.setObject(nonce!, forKey: "payment_nonce") }
        return dict
    }
}

extension PaymentItem: Encodable {
    func encode() -> AnyObject {
        return [
            "id": id,
            "amount": amount,
            "colorId": color,
            "sizeId": size
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
            extOrderId: json =>? "extOrderId",
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
