import Foundation

enum Platform {
    case Polish, German, Worldwide
}

extension Platform {
    static private let allValues: [Platform] = [Polish, German, Worldwide]
    
    init?(code: String) {
        guard let platformToInitialize = Platform.allValues.find({ $0.code == code }) else {
            return nil
        }
        self = platformToInitialize
    }
    
    var code: String {
        switch self {
        case Polish: return "pl"
        case German: return "de"
        case Worldwide: return "en"
        }
    }
    
    var languageCode: String {
        switch self {
        case Polish: return "pl"
        case German: return "de"
        case Worldwide: return "en"
        }
    }
}
