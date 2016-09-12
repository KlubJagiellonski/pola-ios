import Foundation

struct PushTokenRequest {
    let pushToken: String
    let hardwareId: String
}

// MARK:- Encodable

extension PushTokenRequest: Encodable {
    func encode() -> AnyObject {
        return [
            "pushToken": pushToken,
            "hardwareId": hardwareId
        ] as NSDictionary
    }
}
