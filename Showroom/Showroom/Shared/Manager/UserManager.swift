import Foundation

class UserManager {
    private let apiService: ApiService
    
    var gender: Gender {
        return .Female //TODO retrieve from cache
    }
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
}