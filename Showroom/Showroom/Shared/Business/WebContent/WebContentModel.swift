import Foundation
import RxSwift

final class WebContentModel {
    private(set) var webViewId: String
    private let apiService: ApiService
    
    init(apiService: ApiService, webViewId: String) {
        self.apiService = apiService
        self.webViewId = webViewId
    }
    
    func update(withWebViewId webViewId: String) {
        self.webViewId = webViewId
    }
    
    func fetchWebContent() -> Observable<WebContent> {
        return apiService.fetchWebContent(withWebViewId: webViewId)
            .observeOn(MainScheduler.instance)
    }
}