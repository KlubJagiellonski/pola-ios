import Foundation

struct ScanResult: Decodable {
    let productId: Int
    let code: String
    let name: String
    let cardType: CardType
    let plScore: Int?
    let altText: String?
    let plCapital: Int?
    let plWorkers: Int?
    let plRnD: Int?
    let plRegistered: Int?
    let plNotGlobEnt: Int?
    let description: String?
    let reportText: String?
    let reportButtonText: String?
    let reportButtonType: ButtonType
    let isFriend: Bool?
    let ai: AskForAIResult?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case code
        case name
        case cardType = "card_type"
        case plScore
        case altText
        case plCapital
        case plWorkers
        case plRnD
        case plRegistered
        case plNotGlobEnt
        case description
        case reportText = "report_text"
        case reportButtonText = "report_button_text"
        case reportButtonType = "report_button_type"
        case isFriend = "is_friend"
        case ai
    }

    enum CardType: String, Decodable {
        case white = "type_white"
        case grey = "type_grey"
    }

    enum ButtonType: String, Decodable {
        case white = "type_white"
        case red = "type_red"
    }
}
