import Foundation

enum AppLanguage {
    case Polish, German
    
    static let allValues: [AppLanguage] = [Polish, German]
    
    init?(languageCode: String) {
        guard let languageToInitialize = AppLanguage.allValues.find({ $0.languageCode == languageCode }) else {
            return nil
        }
        self = languageToInitialize
    }
    
    var languageCode: String {
        switch self {
        case Polish: return "pl"
        case German: return "de"
        }
    }
    
    var locale: NSLocale {
        return NSLocale(localeIdentifier: self.nsLocaleIdentifier)
    }
    
    private var nsLocaleIdentifier: String {
        switch self {
        case Polish: return "pl"
        case German: return "de"
        }
    }
    
    // temporary
    var platformString: String {
        switch self {
        case Polish: return "showroom.pl"
        case German: return "showroom.de"
        }
    }
}