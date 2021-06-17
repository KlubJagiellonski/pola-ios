import Foundation

struct AskForDonate: Decodable {
    let showButton: Bool
    let url: URL
    let title: String

    enum CodingKeys: String, CodingKey {
        case showButton = "show_button"
        case url
        case title
    }
}
