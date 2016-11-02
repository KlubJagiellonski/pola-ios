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
    
    #if WORLDWIDE
        static let isWorldwideVersion = true
    #else
        static let isWorldwideVersion = false
    #endif
    
    static let appScheme = NSBundle.appScheme
    static let braintreePayPalUrlScheme = "\(NSBundle.mainBundle().bundleIdentifier!).payments"
    
    static let recommendationItemsLimit: Int32 = 20
    static let basketProductAmountLimit: Int = 10
    static let productListPageSize: Int = 20
    static let productListPageSizeForLargeScreen: Int = 27
    static let promoSlideshowTimerStepInterval: Int = 10
    static let promoSlideshowStateChangedAnimationDuration: NSTimeInterval = 0.3
    
    struct Cache {
        static let contentPromoId = "ContentPromoId"
        static let productDetails = "ProductDetails"
        static let productRecommendationsId = "productRecommendationsId"
        static let searchCatalogueId = "searchCatalogueId"
        static let video = "video"
    }
    
    struct Persistent {
        static let basketStateId = "basketStateId"
        static let currentUser = "currentUser"
        static let wishlistState = "wishlistState"
    }
    
    struct UserDefaults {
        static let videoPauseStateCount = "videoPauseStateCount" 
    }
    
    struct ActivityType {
        static let browsing = NSBundle.mainBundle().bundleIdentifier!.stringByAppendingString(".browsing")
    }
}
