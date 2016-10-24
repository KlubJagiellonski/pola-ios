import Foundation

final class RateAppManager {
    private let storage: KeyValueStorage
    private let configurationManager: ConfigurationManager
    private let daysThresholdForShowingView = 14
    private let initialDateKey = "initial_rate_app_date"
    private let appRatedKey = "app_rated"
    
    private var initialDate: NSDate {
        get {
            let initialTimeInterval: NSTimeInterval? = storage.load(forKey: initialDateKey)
            if let timeInterval = initialTimeInterval {
                return NSDate(timeIntervalSince1970: timeInterval)
            } else {
                let initialDate = NSDate()
                storage.save(initialDate.timeIntervalSince1970, forKey: initialDateKey)
                return initialDate
            }
        }
        set {
            logInfo("initialDate \(initialDate)")
            storage.save(newValue.timeIntervalSince1970, forKey: initialDateKey)
        }
    }
    private(set) var appAlreadyRated: Bool {
        get {
            return storage.load(forKey: appRatedKey) ?? false
        }
        set {
            logInfo("appAlreadyRated \(newValue)")
            storage.save(newValue, forKey: appRatedKey)
        }
    }
    
    var shouldShowRateAppView: Bool {
        return !appAlreadyRated && initialDate.numberOfDaysUntilDateTime(NSDate()) >= daysThresholdForShowingView
    }
    
    var appStoreURL: NSURL? {
        return configurationManager.configuration?.appStoreURL
    }
    
    init(storage: KeyValueStorage, configurationManager: ConfigurationManager) {
        self.storage = storage
        self.configurationManager = configurationManager
    }

    func didShowRateAppView() {
        logInfo("Did show app rate view")
        initialDate = NSDate()
    }
    
    func didSelectRemindLater() {
        logInfo("Did select remind later app rate")
        initialDate = NSDate()
    }
    
    func didSelectDeclineRateApp() {
        logInfo("Did select decline rate app")
        appAlreadyRated = true
    }
    
    func didSelectRateApp() {
        logInfo("Did select rate app")
        appAlreadyRated = true
    }
}
