import Foundation
import UIKit

enum AddressInput {
    case Options(addresses: [[AddressFormField]])
    case Form(fields: [AddressFormField])
}

enum AddressFormField {
    case FirstName(value: String?)
    case LastName(value: String?)
    case StreetAndApartmentNumbers(value: String?)
    case PostalCode(value: String?)
    case City(value: String?)
    case Country(defaultValue: String)
    case Phone(value: String?)
}

extension AddressInput {
    static func fromUserAddresses(userAddresses: [UserAddress], defaultCountry: String) -> AddressInput {
        if userAddresses.count > 0 {
            return .Options(addresses: AddressInput.createAddressFormFields(userAddresses))
        } else {
            return .Form(fields: AddressFormField.createEmptyFormFields(withDefaultCountry: defaultCountry))
        }
    }
    
    static func createAddressFormFields(userAddresses: [UserAddress]) -> [[AddressFormField]] {
        var addresses: [[AddressFormField]] = []
        for userAddress in userAddresses {
            addresses.append(AddressFormField.createFormFields(with: userAddress))
        }
        return addresses
    }
}

extension AddressFormField {
    var keyboardType: UIKeyboardType {
        switch self {
        case PostalCode:
            return .NumbersAndPunctuation
        case Phone:
            return .PhonePad
        default:
            return .Default
        }
    }
    
    static func createEmptyFormFields(withDefaultCountry defaultCountry: String) -> [AddressFormField] {
        return [.FirstName(value: nil), .LastName(value: nil), .StreetAndApartmentNumbers(value: nil), .PostalCode(value: nil), .City(value: nil), .Country(defaultValue: defaultCountry), .Phone(value: nil)]
    }
    
    static func createFormFields(with userAddress: UserAddress) -> [AddressFormField] {
        return [
            .FirstName(value: userAddress.firstName),
            .LastName(value: userAddress.lastName),
            .StreetAndApartmentNumbers(value: userAddress.streetAndAppartmentNumbers),
            .PostalCode(value: userAddress.postalCode),
            .City(value: userAddress.city),
            .Country(defaultValue: userAddress.country),
            .Phone(value: userAddress.phone)
        ]
    }
    
    static func formFieldsToUserAddress(formFields: [AddressFormField]) -> UserAddress? {
        var firstName: String?
        var lastName: String?
        var streetAndApartmentNumbers: String?
        var postalCode: String?
        var city: String?
        var country: String?
        var phone: String?
        
        for formField in formFields {
            switch formField {
            case .FirstName(let value):
                firstName = value
            case .LastName(let value):
                lastName = value
            case .StreetAndApartmentNumbers(let value):
                streetAndApartmentNumbers = value
            case .PostalCode(let value):
                postalCode = value
            case .City(let value):
                city = value
            case .Country(let value):
                country = value
            case .Phone(let value):
                phone = value
            }
        }
        guard let fn = firstName, let ln = lastName, let saan = streetAndApartmentNumbers, let pc = postalCode, let ci = city, let co = country, let p = phone else {
            return nil
        }
        
        return UserAddress(firstName: fn, lastName: ln, streetAndAppartmentNumbers: saan, postalCode: pc, city: ci, country: co, phone: p)
    }
}