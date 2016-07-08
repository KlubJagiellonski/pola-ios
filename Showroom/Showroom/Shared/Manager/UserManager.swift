import Foundation

class UserManager {
    private static let skipStartScreenKey = "SkipStartScreen"
    
    private let apiService: ApiService
    let user: User
    var gender: Gender = .Female
    
    var shouldSkipStartScreen: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(UserManager.skipStartScreenKey);
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserManager.skipStartScreenKey);
        }
    }
    
    init(apiService: ApiService) {
        self.apiService = apiService
        let mockedUserAddresses = [
            UserAddress(firstName: "Jan", lastName: "Kowalski", streetAndAppartmentNumbers: "Sikorskiego 12/30", postalCode: "15-888", city: "Białystok", country: "POLSKA", phone: "+48 501 123 456"),
            UserAddress(firstName: "Anna", lastName: "Kowalska", streetAndAppartmentNumbers: "Piękna 5/10", postalCode: "02-758", city: "Warszawa", country: "POLSKA", phone: "+48 788 123 456")
        ]
        self.user = User(userAddresses: mockedUserAddresses)
    }
}

enum Gender: String {
    case Male = "male"
    case Female = "female"
}