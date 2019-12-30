import Foundation

struct AskForAIResult: Decodable {
    let askForPics: Bool
    let askForPicsPreview: String
    let askForPicsTitle: String
    let askForPicsText: String
    let askForPicsButtonStart: String
    let askForPicsProduct: String
    let maxPicSize: Double
    
    enum CodingKeys: String, CodingKey {
        case askForPics = "ask_for_pics"
        case askForPicsPreview = "ask_for_pics_preview"
        case askForPicsTitle = "ask_for_pics_title"
        case askForPicsText = "ask_for_pics_text"
        case askForPicsButtonStart = "ask_for_pics_button_start"
        case askForPicsProduct = "ask_for_pics_product"
        case maxPicSize = "max_pic_size"
    }
}
