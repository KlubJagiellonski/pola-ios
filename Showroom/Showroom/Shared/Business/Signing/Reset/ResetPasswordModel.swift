import Foundation
import RxSwift

final class ResetPasswordModel {
    private let api: ApiService
    
    init(with api: ApiService) {
        self.api = api
    }
    
    func resetPassword(withEmail email: String) -> Observable<Void> {
        return api.resetPassword(withEmail: email).observeOn(MainScheduler.instance)
    }
}