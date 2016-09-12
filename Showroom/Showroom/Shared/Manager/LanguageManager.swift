import Foundation

extension NSUserDefaults: KeyValueCache { }

final class PlatformLanguageManager {
    private static let languageCodeKey = "LanguageCode"
    private let cache: KeyValueCache
    
    private(set) var availableLanguages: [AppLanguage] = AppLanguage.allValues

    private(set) var shouldSkipPlatformSelection: Bool {
        get {
            return cache.boolForKey("shouldSkipPlatformSelectionView")
        }
        set {
            cache.setBool(newValue, forKey: "shouldSkipPlatformSelectionView")
        }
    }
    
    init(keyValueCache: KeyValueCache = NSUserDefaults.standardUserDefaults()) {
        self.cache = keyValueCache
    }
    
    var language: AppLanguage? {
        set {
            guard let newValue = newValue else {
                logError("Tried to set language to nil")
                return
            }
            cache.setObject(newValue.languageCode, forKey: PlatformLanguageManager.languageCodeKey)
            let success = cache.synchronize()
            if success {
                logInfo("Did set app language: \(newValue) to user defaults")
                shouldSkipPlatformSelection = true
            } else {
                logError("Failed to set app language \(newValue) to user defaults")
            }
        }
        get {
            guard let languageCode = cache.stringForKey(PlatformLanguageManager.languageCodeKey) else {
                logError("Could not find language code in user defaults for key: \(PlatformLanguageManager.languageCodeKey)")
                return nil
            }
            guard let language = AppLanguage(languageCode: languageCode) else {
                logError("No available language with language code: \(languageCode)")
                return nil
            }
            return language
        }
    }
    
    func translation(forKey key: String) -> String? {
        guard let languageCode = language?.languageCode else { return nil }
        let budleType = "lproj"
        guard let bundlePath = NSBundle.mainBundle().pathForResource(languageCode, ofType: budleType) else {
            logError("Could not find bundle path for resource: \(languageCode).\(budleType)")
            return nil
        }
        guard let languageBundle = NSBundle(path: bundlePath) else {
            logError("Could not find bundle with path: \(bundlePath)")
            return nil
        }
        let translatedString = languageBundle.localizedStringForKey(key, value: "", table: nil)
        guard !translatedString.isEmpty else {
            logError("No localizable string file for the selected language")
            return nil
        }
        return translatedString
    }
    
    // search for current device language in available languages. set matching one if possible.
    func initializePlatform() {
        if !shouldSkipPlatformSelection {
            let deviceLanguageCode = NSLocale.currentLocale().languageCode
            logInfo("Trying to find available app language matching the device language with languageCode: \(deviceLanguageCode)")
            
            if let matchingAvailableLanguage =
                availableLanguages
                    .find({ $0.languageCode == deviceLanguageCode }) {
                language = matchingAvailableLanguage
                // TODO: set platform
                shouldSkipPlatformSelection = true
            }
        }
    }
}