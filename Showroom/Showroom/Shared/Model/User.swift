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

// MARK:- Equatable

extension User: Equatable {}
extension UserAddress: Equatable {}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email && lhs.userAddresses == rhs.userAddresses
}
func ==(lhs: UserAddress, rhs: UserAddress) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.streetAndAppartmentNumbers == rhs.streetAndAppartmentNumbers && lhs.postalCode == rhs.postalCode && lhs.city == rhs.city && lhs.country == rhs.country && lhs.phone == rhs.phone && lhs.description == rhs.description
}