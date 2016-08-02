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
    static func fromUserAddresses(userAddresses: [UserAddress], defaultCountry: String, isFormMode: Bool) -> AddressInput {
        if isFormMode {
            if let userAddress = userAddresses.first {
                return .Form(fields: AddressFormField.createFormFields(with: userAddress, defaultCountry: defaultCountry))
            } else {
                return .Form(fields: AddressFormField.createEmptyFormFields(withDefaultCountry: defaultCountry))
            }
        } else {
            return .Options(addresses: AddressInput.createAddressFormFields(userAddresses, defaultCountry: defaultCountry))
        }
    }
    
    static func createAddressFormFields(userAddresses: [UserAddress], defaultCountry: String) -> [[AddressFormField]] {
        var addresses: [[AddressFormField]] = []
        for userAddress in userAddresses {
            addresses.append(AddressFormField.createFormFields(with: userAddress, defaultCountry: defaultCountry))
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
    
    var fieldId: String {
        switch self {
        case .FirstName:
            return UserAddress.firstNameKey
        case .LastName:
            return UserAddress.lastNameKey
        case .StreetAndApartmentNumbers:
            return UserAddress.streetAndAppartmentNumbersKey
        case .PostalCode:
            return UserAddress.postalCodeKey
        case .City:
            return UserAddress.cityKey
        case .Country:
            return UserAddress.countryKey
        case .Phone:
            return UserAddress.phoneKey
        }
    }
    
    static func createEmptyFormFields(withDefaultCountry defaultCountry: String) -> [AddressFormField] {
        return [.FirstName(value: nil), .LastName(value: nil), .StreetAndApartmentNumbers(value: nil), .PostalCode(value: nil), .City(value: nil), .Country(defaultValue: defaultCountry), .Phone(value: nil)]
    }
    
    static func createFormFields(with userAddress: UserAddress, defaultCountry: String) -> [AddressFormField] {
        return [
            .FirstName(value: userAddress.firstName),
            .LastName(value: userAddress.lastName),
            .StreetAndApartmentNumbers(value: userAddress.streetAndAppartmentNumbers),
            .PostalCode(value: userAddress.postalCode),
            .City(value: userAddress.city),
            .Country(defaultValue: defaultCountry),
            .Phone(value: userAddress.phone)
        ]
    }
    
    static func formFieldsToUserAddress(formFields: [AddressFormField]) -> EditUserAddress? {
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
        
        return EditUserAddress(firstName: fn, lastName: ln, streetAndAppartmentNumbers: saan, postalCode: pc, city: ci, country: co, phone: p, description: nil)
    }
}