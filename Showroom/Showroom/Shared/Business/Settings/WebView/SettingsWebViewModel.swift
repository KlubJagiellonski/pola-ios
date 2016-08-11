import Foundation
import RxSwift

enum SettingsWebType {
    case UserData, History, HowToMeasure, PrivacyPolicy, FrequestQuestions, Rules, Contact
}

typealias WebContentResult = String

class SettingsWebViewModel {
    
    private let apiService: ApiService
    private let webType: SettingsWebType
    
    init(apiService: ApiService, settingsWebType: SettingsWebType) {
        self.apiService = apiService
        self.webType = settingsWebType
    }
    
    func fetchWebContent() -> Observable<WebContentResult> {
        return apiService.fetchSettingsWebContent(settingsWebType: webType).observeOn(MainScheduler.instance)
    }
}