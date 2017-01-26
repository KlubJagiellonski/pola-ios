import Foundation
import RxSwift

final class WebContentModel {
    private(set) var entry: WebContentEntry
    private let apiService: ApiService
    
    init(apiService: ApiService, entry: WebContentEntry) {
        self.apiService = apiService
        self.entry = entry
    }
    
    func update(with entry: WebContentEntry) {
        self.entry = entry
    }
    
    func fetchWebContent() -> Observable<WebContent> {
        return apiService.fetchWebContent(withWebViewId: entry.id)
            .observeOn(MainScheduler.instance)
    }
}
