import Foundation

struct Company: Decodable {
    let name: String
    let plScore: Int?
    let altText: String?
    let plCapital: Int?
    let plWorkers: Int?
    let plRnD: Int?
    let plRegistered: Int?
    let plNotGlobEnt: Int?
    let description: String?
    let friendText: String?
    let isFriend: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case plScore
        case altText
        case plCapital
        case plWorkers
        case plRnD
        case plRegistered
        case plNotGlobEnt
        case description
        case friendText = "friend_text"
        case isFriend = "is_friend"
    }
}
