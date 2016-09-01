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
    
    #if ENV_STAGING
        static let isStagingEnv = true
    #else
        static let isStagingEnv = false
    #endif
    
    static let appScheme = NSBundle.appScheme
    
    static let appStoreUrl = "itms-apps://itunes.apple.com/app/id1147114961"
    
    static let optimiseApiKey = "72933403-B469-41FD-B6E4-635B5B44584F"
    static let optimiseMerchantId = 990079
    static let optimiseTrackInstallProductId = 28575
    static let optimiseTrackSaleProductId = 28577
    static let optimiseTrackRegistrationProductId = 28576
    
    static let braintreePayPalUrlScheme = "\(NSBundle.mainBundle().bundleIdentifier!).payments"
    
    #if APPSTORE
    static let googleAnalyticsTrackingId = "UA-28549987-7"
    #else
    static let googleAnalyticsTrackingId = "UA-28549987-11"
    #endif
    static let emarsysMerchantId = "13CE3A05D54F66DD"
    static let emarsysRecommendationItemsLimit: Int32 = 20
    static let emarsysPushPassword = "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v"
    static let basketProductAmountLimit: Int = 10
    static let productListPageSize: Int = 20
    static let productListPageSizeForLargeScreen: Int = 27
    
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