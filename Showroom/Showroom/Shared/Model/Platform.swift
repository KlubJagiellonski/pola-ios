import Foundation

enum Platform {
    case Polish, German
}

extension Platform {
    static let allValues: [Platform] = [Polish, German]
    
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
        }
    }
}