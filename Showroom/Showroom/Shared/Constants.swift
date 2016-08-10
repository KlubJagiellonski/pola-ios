import Foundation

struct Constants {
    #if DEBUG
        static let isDebug = true
    #else
        static let isDebug = false
    #endif
    
    #if APPSTORE
        static let isAppStore = true
    #else
        static let isAppStore = false
    #endif
    
    static let baseUrl = "https://api.showroom.pl/ios/v1"
    static let websiteDomain = "www.showroom.pl"
    static let websiteUrl = "https://\(Constants.websiteDomain)"
    static let appScheme = NSBundle.appScheme
    
    #if APPSTORE
    static let googleAnalyticsTrackingId = "UA-28549987-1"
    #else
    static let googleAnalyticsTrackingId = "UA-81404441-1"
    #endif
    static let emarsysMerchantId = "13CE3A05D54F66DD"
    static let emarsysRecommendationItemsLimit: Int32 = 20
    static let emarsysPushPassword = "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v"
    static let basketProductAmountLimit: Int = 10
    static let productListPageSize: Int = 20
    static let productListPageSizeForLargeScreen: Int = 27
    
    static let rootCategoryId: ObjectId = -1
    
    struct Cache {
        static let contentPromoId = "ContentPromoId"
        static let productDetails = "ProductDetails"
        static let productRecommendationsId = "productRecommendationsId"
        static let searchCatalogueId = "searchCatalogueId" 
    }
    
    struct Persistent {
        static let basketStateId = "basketStateId"
        static let currentUser = "currentUser"
        static let wishlistState = "wishlistState"
    }
    
    struct ActivityType {
        static let browsing = NSBundle.mainBundle().bundleIdentifier!.stringByAppendingString(".browsing")
    }
}