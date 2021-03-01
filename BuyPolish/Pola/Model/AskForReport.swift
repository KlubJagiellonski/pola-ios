import Foundation

struct AskForReport: Decodable {
    let text: String?
    let buttonText: String?
    let buttonType: ButtonType

    enum CodingKeys: String, CodingKey {
        case text
        case buttonText = "button_text"
        case buttonType = "button_type"
    }

    enum ButtonType: String, Decodable {
        case white = "type_white"
        case red = "type_red"
    }
}
