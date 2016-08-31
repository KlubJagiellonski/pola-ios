import Foundation

struct PushTokenRequest {
    let pushToken: String
    let hardwareId: String
}

// MARK:- Encodable

extension PushTokenRequest: Encodable {
    func encode() -> AnyObject {
        return [
            "push_token": pushToken,
            "hardware_id": hardwareId
        ] as NSDictionary
    }
}
