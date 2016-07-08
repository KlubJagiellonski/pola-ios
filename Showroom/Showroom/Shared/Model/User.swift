import Foundation

struct User {
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
}