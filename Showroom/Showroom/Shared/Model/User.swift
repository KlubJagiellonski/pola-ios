import Foundation

struct User {
    let gender: Gender
    let userAddresses: [UserAddress]
}

enum Gender: String {
    case Male = "male"
    case Female = "female"
}

struct UserAddress {
    let firstName: String
    let lastName: String
    let streetAndAppartmentNumbers: String
    let postalCode: String
    let city: String
    let country: String
    let phone: String
}