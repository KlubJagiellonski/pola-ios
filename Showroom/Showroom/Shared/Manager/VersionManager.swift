import Foundation
import RxSwift

/// There are 3 types of versions:
/// - installed version - version of the installed app
/// - saved version - the stored version after the last check from the backend
/// - latest version - the actual latest version of the app just received from the backend
final class VersionManager {
    private let daysThresholdForShowingView = 7
    private let initialDateKey = "versionCheckDate"
    private let savedVersionKey = "savedVersion"
    private let dontUpdateKey = "dontUpdate"
    
    private let api: ApiService
    private let storage: KeyValueStorage
    
    private let installedVersion: String
    private var latestVersion: String
    
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
            logInfo("Last version check date: \(initialDate)")
            storage.save(newValue.timeIntervalSince1970, forKey: initialDateKey)
        }
    }
    
    private var savedVersion: String {
        get {
            return storage.load(forKey: savedVersionKey) ?? installedVersion
        }
        set {
            logInfo("Latest stored version: \(newValue)")
            storage.save(newValue, forKey: savedVersionKey)
        }
    }
    
    private var dontUpdateToTheSavedVersion: Bool {
        get {
            return storage.load(forKey: dontUpdateKey) ?? false
        }
        set {
            storage.save(newValue, forKey: dontUpdateKey)
        }
    }
    
    var shouldShowUpdateAlert: Bool {
        // Cases to show update alert:
        // - The new version is different that the saved one
        // - The new version is different that the installed one, user did not decline the alert and it is more than 7 days after the last update alert
        
        if latestVersion != savedVersion {
            savedVersion = latestVersion
            dontUpdateToTheSavedVersion = false
            return true
        }
        
        return latestVersion != installedVersion
            && !dontUpdateToTheSavedVersion
            && initialDate.numberOfDaysUntilDateTime(NSDate()) >= daysThresholdForShowingView
    }
    
    init(api: ApiService, storage: KeyValueStorage) {
        self.api = api
        self.storage = storage
        self.installedVersion = VersionManager.checkInstalledVersion()
        self.latestVersion = self.installedVersion
    }
    
    class func checkInstalledVersion() -> String {
        let version = NSBundle.appVersionNumber
        logInfo("Installed version: \(version)")
        return version
    }
    
    func fetchLatestVersion() -> Observable<AppVersion> {
        return api.fetchAppVersion().observeOn(MainScheduler.instance)
            .doOnNext { [weak self] (appVersion: AppVersion) in
                self?.latestVersion = appVersion.version
            }.asObservable()
    }
    
    func didShowVersionAlert() {
        logInfo("Did show app update alert")
        initialDate = NSDate()
    }
    
    func didSelectUpdate() {
        logInfo("Did select update")
    }
    
    func didSelectRemindLater() {
        logInfo("Did select remind later about app update")
    }
    
    func didSelectDecline() {
        logInfo("Did select decline app update")
        dontUpdateToTheSavedVersion = true
    }
}