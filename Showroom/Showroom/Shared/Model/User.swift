import Foundation
import Decodable

struct User {
    let id: Int
    let name: String
    let email: String
    let userAddresses: [UserAddress]
}

struct UserAddress {
    let firstName: String
    let lastName: String
    let streetAndAppartmentNumbers: String
    let postalCode: String
    let city: String
    let country: String
    let phone: String
    let description: String?
}

// MARK: - Decodable, Encodable

extension User: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> User {
        return try User(
            id: json => "id",
            name: json => "name",
            email: json => "email",
            userAddresses: json => "addresses")
    }
    
    func encode() -> AnyObject {
        let addressesArray: NSMutableArray = []
        for address in userAddresses {
            addressesArray.addObject(address.encode())
        }
        return [
            "id": id,
            "name": name,
            "email": email,
            "addresses": addressesArray
        ] as NSDictionary
    }
}

extension UserAddress: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> UserAddress {
        return try UserAddress(
            firstName: json => "name",
            lastName: json => "surname",
            streetAndAppartmentNumbers: json => "street",
            postalCode: json => "zip",
            city: json => "city",
            country: json => "country",
            phone: json => "phone",
            description: json => "description")
    }
    
    func encode() -> AnyObject {
        return [
            "name": firstName,
            "surname": lastName,
            "street": streetAndAppartmentNumbers,
            "zip": postalCode,
            "city": city,
            "country": country,
            "phone": phone,
            "description": description ?? ""
        ] as NSDictionary
    }
}