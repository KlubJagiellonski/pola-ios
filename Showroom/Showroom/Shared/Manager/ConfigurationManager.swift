import Foundation
import RxSwift

struct ConfigurationInfo {
    let configuration: Configuration
    let oldConfiguration: Configuration?
}

final class ConfigurationManager {
    private static let platformCodeKey = "PlatformCodeKey"
    
    private let apiService: ApiService
    private let storage: KeyValueStorage
    private let disposeBag = DisposeBag()
    
    let availablePlatforms: [Platform]
    let configurationObservable = PublishSubject<ConfigurationInfo>()
    
    private(set) var configuration: Configuration? {
        didSet {
            guard let configuration = configuration else {
                logError("Cannot unset configuration")
                return
            }
            Analytics.sharedInstance.configuration = configuration.analyticsConfiguration
            apiService.basePath = configuration.apiBasePath
            configurationObservable.onNext(ConfigurationInfo(configuration: configuration, oldConfiguration: oldValue))
        }
    }
    var platform: Platform? {
        set {
            guard let newValue = newValue else {
                logError("Tried to set platform to nil")
                return
            }
            storage.clear(forType: .Cache)
            storage.clear(forType: .Persistent)
            
            if storage.save(newValue.code, forKey: ConfigurationManager.platformCodeKey) {
                logInfo("Did set app platform: \(newValue) to user defaults")
                shouldSkipPlatformSelection = true
            } else {
                logError("Failed to set app platform \(newValue) to user defaults")
            }
            self.configuration = createConfiguration(forPlatform: newValue)
        }
        get {
            guard let platformCode: String = storage.load(forKey: ConfigurationManager.platformCodeKey) else {
                logError("Could not find language code in user defaults for key: \(ConfigurationManager.platformCodeKey)")
                return nil
            }
            guard let platform = Platform(code: platformCode) else {
                logError("No available platform with code: \(platformCode)")
                return nil
            }
            return platform
        }
    }
    
    private(set) var shouldSkipPlatformSelection: Bool {
        get {
            return storage.load(forKey: "shouldSkipPlatformSelectionView") ?? false
        }
        set {
            storage.save(newValue, forKey: "shouldSkipPlatformSelectionView")
        }
    }
    
    init(apiService: ApiService, keyValueStorage: KeyValueStorage) {
        self.apiService = apiService
        self.storage = keyValueStorage
        self.availablePlatforms = Constants.isWorldwideVersion ? [Platform.Worldwide] : [Platform.Polish, Platform.German]
    }
    
    func inititialize() {
        if let platform = self.platform {
            self.configuration = createConfiguration(forPlatform: platform)
        }
        
        if !shouldSkipPlatformSelection {
            if availablePlatforms.count == 1 {
                platform = availablePlatforms[0]
            } else {
                let deviceLanguageCode = NSLocale.currentLocale().appLanguageCode
                logInfo("Trying to find available app platform matching the device language with languageCode: \(deviceLanguageCode)")
                
                if let matchingAvailableLanguage = availablePlatforms.find({ $0.languageCode == deviceLanguageCode }) {
                    platform = matchingAvailableLanguage
                }
            }
        }
    }
    
    func translation(forKey key: String) -> String? {
        guard let languageCode = platform?.languageCode else { return nil }
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
    
    private func createConfiguration(forPlatform platform: Platform) -> Configuration {
        switch platform {
        case .Polish:
            return PlConfiguration()
        case .German:
            return DeConfiguration()
        case .Worldwide:
            return ComConfiguration()
        }
    }
}
