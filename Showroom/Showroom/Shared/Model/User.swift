import Foundation
import Decodable

struct User {
    let id: Int
    let name: String
    let email: String
    let gender: Gender
    let userAddresses: [UserAddress]
}

struct UserAddress {
    static let idKey = "id"
    static let firstNameKey = "name"
    static let lastNameKey = "surname"
    static let streetAndAppartmentNumbersKey = "street"
    static let postalCodeKey = "zip"
    static let cityKey = "city"
    static let countryKey = "country"
    static let phoneKey = "phone"
    static let descriptionKey = "description"
    
    let id: ObjectId
    let firstName: String
    let lastName: String
    let streetAndAppartmentNumbers: String
    let postalCode: String
    let city: String
    let country: String
    let phone: String
    let description: String?
}

struct EditUserAddress {
    let firstName: String
    let lastName: String
    let streetAndAppartmentNumbers: String
    let postalCode: String
    let city: String
    let country: String
    let phone: String
    let description: String?
}

// MARK:- Errors

enum EditAddressError: ErrorType {
    case ValidationFailed(EditAddressFieldErrors)
    case Unknown(ErrorType)
}

struct EditAddressValidationError {
    let message: String
    let errors: EditAddressFieldErrors
}

struct EditAddressFieldErrors {
    let firstName: String?
    let lastName: String?
    let streetAndAppartmentNumbers: String?
    let postalCode: String?
    let city: String?
    let country: String?
    let phone: String?
    let description: String?
}

// MARK: - Decodable, Encodable

extension User: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> User {
        return try User(
            id: json => "id",
            name: json => "name",
            email: json => "email",
            gender: Gender(rawValue: json => "gender")!,
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
            "gender": gender.rawValue,
            "addresses": addressesArray
        ] as NSDictionary
    }
}

extension UserAddress: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> UserAddress {
        return try UserAddress(
            id: json => UserAddress.idKey,
            firstName: json => UserAddress.firstNameKey,
            lastName: json => UserAddress.lastNameKey,
            streetAndAppartmentNumbers: json => UserAddress.streetAndAppartmentNumbersKey,
            postalCode: json => UserAddress.postalCodeKey,
            city: json => UserAddress.cityKey,
            country: json => UserAddress.countryKey,
            phone: json => UserAddress.phoneKey,
            description: json =>? UserAddress.descriptionKey
        )
    }
    
    func encode() -> AnyObject {
        return [
            UserAddress.idKey: id,
            UserAddress.firstNameKey: firstName,
            UserAddress.lastNameKey: lastName,
            UserAddress.streetAndAppartmentNumbersKey: streetAndAppartmentNumbers,
            UserAddress.postalCodeKey: postalCode,
            UserAddress.cityKey: city,
            UserAddress.countryKey: country,
            UserAddress.phoneKey: phone,
            UserAddress.descriptionKey: description ?? ""
        ] as NSDictionary
    }
}

extension EditUserAddress: Encodable {
    func encode() -> AnyObject {
        return [
            UserAddress.firstNameKey: firstName,
            UserAddress.lastNameKey: lastName,
            UserAddress.streetAndAppartmentNumbersKey: streetAndAppartmentNumbers,
            UserAddress.postalCodeKey: postalCode,
            UserAddress.cityKey: city,
            UserAddress.countryKey: country,
            UserAddress.phoneKey: phone,
            UserAddress.descriptionKey: description ?? ""
            ] as NSDictionary
    }
}

extension EditAddressValidationError: Decodable {
    static func decode(json: AnyObject) throws -> EditAddressValidationError {
        return try EditAddressValidationError(
            message: json => "message",
            errors: json => "errors"
        )
    }
}

extension EditAddressFieldErrors: Decodable {
    static func decode(json: AnyObject) throws -> EditAddressFieldErrors {
        return try EditAddressFieldErrors(
            firstName: json => UserAddress.firstNameKey,
            lastName: json => UserAddress.lastNameKey,
            streetAndAppartmentNumbers: json => UserAddress.streetAndAppartmentNumbersKey,
            postalCode: json => UserAddress.postalCodeKey,
            city: json => UserAddress.cityKey,
            country: json => UserAddress.countryKey,
            phone: json => UserAddress.phoneKey,
            description: json =>? UserAddress.descriptionKey
        )
    }
}


// MARK:- Equatable

extension User: Equatable {}
extension UserAddress: Equatable {}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email && lhs.userAddresses == rhs.userAddresses && lhs.gender == rhs.gender
}
func ==(lhs: UserAddress, rhs: UserAddress) -> Bool {
    return lhs.id == rhs.id && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.streetAndAppartmentNumbers == rhs.streetAndAppartmentNumbers && lhs.postalCode == rhs.postalCode && lhs.city == rhs.city && lhs.country == rhs.country && lhs.phone == rhs.phone && lhs.description == rhs.description
}