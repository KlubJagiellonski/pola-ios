import Foundation

struct Constants {
    #if DEBUG
        static let isDebug = true
    #else
        static let isDebug = false
    #endif
    
    static let baseUrl = "https://api.showroom.pl/ios/v1"
    
    struct Cache {
        static let contentPromoId = "ContentPromoId"
    }
}