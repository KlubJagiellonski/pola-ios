import Foundation
import Decodable

struct KioskResult {
    let kiosks: [Kiosk]
}

struct Kiosk {
    let id: ObjectId
    let city: String
    let street: String
    let displayName: String
    let distance: Double
    let workingHours: [String]
}

// MARK: - Decodable

extension KioskResult: Decodable {
    static func decode(json: AnyObject) throws -> KioskResult {
        let array = json as! [AnyObject]
        return KioskResult(kiosks: try array.map(Kiosk.decode))
    }
}

extension Kiosk: Decodable {
    static func decode(j: AnyObject) throws -> Kiosk {
        let workingHours = try j => "workingHours"
        guard let woringHoursString = workingHours as? String else {
            throw TypeMismatchError.init(expectedType: String.self, receivedType: AnyObject.self, object: j)
        }
        let workingHoursArray: [String] = woringHoursString.componentsSeparatedByString(",").map {
            $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        return try Kiosk(
            id: j => "id",
            city: j => "city",
            street: j => "street",
            displayName: j => "displayName",
            distance: j => "distance",
            workingHours: workingHoursArray
        )
    }
}