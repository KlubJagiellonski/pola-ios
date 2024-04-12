import Foundation

struct Brand: Decodable {
    let name: String
    let logotypeUrl: URL?

    enum CodingKeys: String, CodingKey {
        case name
        case logotypeUrl = "logotype_url"
    }
}
