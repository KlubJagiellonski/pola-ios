import Foundation

final class RateAppManager {
    private let daysThreesholdForShowingView = 14
    private let initialDateKey = "initial_rate_app_date"
    private let appRatedKey = "app_rated"
    
    private var initialDate: NSDate {
        get {
            let initialTimeInterval = NSUserDefaults.standardUserDefaults().objectForKey(initialDateKey) as? NSTimeInterval
            if let timeInterval = initialTimeInterval {
                return NSDate(timeIntervalSince1970: timeInterval)
            } else {
                let initialDate = NSDate()
                NSUserDefaults.standardUserDefaults().setDouble(initialDate.timeIntervalSince1970, forKey: initialDateKey)
                return initialDate
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setDouble(newValue.timeIntervalSince1970, forKey: initialDateKey)
        }
    }
    private(set) var appAlreadyRated: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(appRatedKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: appRatedKey)
        }
    }
    
    var shouldShowRateAppView: Bool {
        return !appAlreadyRated && initialDate.numberOfDaysUntilDateTime(NSDate()) >= daysThreesholdForShowingView
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
