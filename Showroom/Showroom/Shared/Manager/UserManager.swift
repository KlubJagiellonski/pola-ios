import Foundation

class UserManager {
    private let apiService: ApiService
    let user: User
    
    init(apiService: ApiService) {
        self.apiService = apiService
        let mockedUserAddresses = [
            UserAddress(firstName: "Jan", lastName: "Kowalski", streetAndAppartmentNumbers: "Sikorskiego 12/30", postalCode: "15-888", city: "Białystok", country: "POLSKA", phone: "+48 501 123 456"),
            UserAddress(firstName: "Anna", lastName: "Kowalska", streetAndAppartmentNumbers: "Piękna 5/10", postalCode: "02-758", city: "Warszawa", country: "POLSKA", phone: "+48 788 123 456")
        ]
        self.user = User(gender: .Female, userAddresses: mockedUserAddresses)
    }
}