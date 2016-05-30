import Foundation
import RxSwift

class DashboardModel {
    let apiService: ApiService
    let userManager: UserManager
    
    init(apiService: ApiService, userManager: UserManager) {
        self.apiService = apiService
        self.userManager = userManager
    }
    
    func fetchContentPromo() -> Observable<[ContentPromo]> {
        return apiService.fetchContentPromo(withGender: userManager.gender) //TODO add caching
    }
}