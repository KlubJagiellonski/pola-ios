import Foundation

protocol KeyValueCache {
    func synchronize() -> Bool
    func setObject(value: AnyObject?, forKey defaultName: String)
    func stringForKey(defaultName: String) -> String?
    func setBool(value: Bool, forKey defaultName: String)
    func boolForKey(defaultName: String) -> Bool
}

extension NSUserDefaults: KeyValueCache { }

final class LanguageManager {
    private static let languageCodeKey = "LanguageCode"
    private let cache: KeyValueCache
    
    private(set) var availableLanguages: [AppLanguage] = AppLanguage.allValues

    var shouldSkipPlatformSelection: Bool {
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
            cache.setObject(newValue.languageCode, forKey: LanguageManager.languageCodeKey)
            let success = cache.synchronize()
            logInfo("Did set language: \(newValue) in user defaults with success: \(success)")
        }
        get {
            guard let languageCode = cache.stringForKey(LanguageManager.languageCodeKey) else {
                logError("Could not find language code in user defaults for key: \(LanguageManager.languageCodeKey)")
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
}