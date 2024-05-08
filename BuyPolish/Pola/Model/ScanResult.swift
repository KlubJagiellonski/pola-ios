import Foundation

struct ScanResult: Decodable {
    let productId: Int
    let code: String
    let name: String?
    let cardType: CardType
    let altText: String?
    let companies: [Company]?
    let report: AskForReport?
    let donate: AskForDonate?
    let allCompanyBrands: [Brand]?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case code
        case name
        case cardType = "card_type"
        case altText
        case companies
        case report
        case donate
        case allCompanyBrands = "all_company_brands"
    }

    enum CardType: String, Decodable {
        case white = "type_white"
        case grey = "type_grey"
    }
}
