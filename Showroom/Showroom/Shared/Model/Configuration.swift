import Foundation

struct EmarsysConfiguration {
    let pushPassword: String
    let pushwooshAppId: String
}

struct BraintreeConfiguration {
    let payPalUrlScheme: String
}

enum OptimiseAnalyticsType: String {
    case Kids = "Kids"
    case NonKids = "Non-Kids"
}

struct AnalyticsConfiguration {
    let googleTrackingId: String
    let googleConversionId: String
    let googleConversionAppStartLabel: String
    let googleConversionTransactionLabel: String
    let optimiseApiKey = "72933403-B469-41FD-B6E4-635B5B44584F"
    let optimiseMerchantId = 990079
    let optimiseTrackInstallProductId = 28575
    let optimiseTrackSaleProductId = 28577
    let optimiseTrackRegistrationProductId = 28576
    let optimiseCategory: String
    let optimiseType: OptimiseAnalyticsType
    let emarsysMerchantId: String
}

struct DeepLinkConfiguration {
    let brandPathComponent: String
    let productPathComponent: String
    let productListPathComponent: String
    let cartPathComponent: String
    let searchPathComponent: String
    let trendPathComponent: String
    let videosPathComponent: String
    let staticWebPagePathComponent: String
    let wishlistPathComponent: String
}

struct SettingsConfiguration {
    let howToMeasureText: L10n?
}

protocol Configuration {
    var appStoreURL: NSURL { get }
    var apiBasePath: String { get }
    var feedbackEmail: String { get }
    var availableGenders: [Gender] { get }
    var platformDescription: String { get }
    var webPageURL: NSURL { get }
    var currencyCode: String { get }
    var locale: NSLocale { get }
    var analyticsConfiguration: AnalyticsConfiguration { get }
    var emarsysConfiguration: EmarsysConfiguration { get }
    var braintreeConfiguration: BraintreeConfiguration { get }
    var deepLinkConfiguration: DeepLinkConfiguration { get }
    var settingsConfiguration: SettingsConfiguration { get }
}

extension Configuration {
    var braintreeConfiguration: BraintreeConfiguration {
        return BraintreeConfiguration(
            payPalUrlScheme: "\(NSBundle.mainBundle().bundleIdentifier!).payments"
        )
    }
}

// MARK:- Configurations

final class PlConfiguration: Configuration {
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1147114961")!
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let settingsConfiguration: SettingsConfiguration
    let feedbackEmail = "ios@showroom.pl"
    let availableGenders: [Gender] = [.Male, .Female]
    let platformDescription = "showroom.pl"
    let webPageURL: NSURL
    let currencyCode = "PLN"
    let locale = NSLocale(localeIdentifier: "pl")
    
    init() {
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-7" : "UA-28549987-11",
            googleConversionId: "1006448960",
            googleConversionAppStartLabel: "sTFZCITB7WoQwOL03wM",
            googleConversionTransactionLabel: "VJLuCLvF72oQwOL03wM",
            optimiseCategory: "PL",
            optimiseType: .NonKids,
            emarsysMerchantId: "13CE3A05D54F66DD"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v",
            pushwooshAppId: "63A3E-B6CDA"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marki",
            productPathComponent: "p",
            productListPathComponent: "tag",
            cartPathComponent: "c/cart/view",
            searchPathComponent: "search",
            trendPathComponent: "trend",
            videosPathComponent: "videos",
            staticWebPagePathComponent: "d",
            wishlistPathComponent: "c/wishlist"
        )
        settingsConfiguration = SettingsConfiguration(
            howToMeasureText: .SettingsHowToMeasure
        )
        let versionComponent = Constants.isStagingEnv ? "api-test" : "api"
        apiBasePath = "https://\(versionComponent).showroom.pl/ios/v2"
        
        if Constants.isStagingEnv {
            webPageURL = NSURL(string: "https://pl.test.shwrm.net")!
        } else {
            webPageURL = NSURL(string: "https://www.showroom.pl")!
        }
    }
}

final class DeConfiguration: Configuration {
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1147114961")!
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let settingsConfiguration: SettingsConfiguration
    let feedbackEmail = "ios@showroom.de"
    let availableGenders: [Gender] = [.Female]
    let platformDescription = "showroom.de"
    let webPageURL: NSURL
    let currencyCode = "EUR"
    let locale = NSLocale(localeIdentifier: "de")
    
    init() {
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-13" : "UA-28549987-11",
            googleConversionId: "942368511",
            googleConversionAppStartLabel: "xIPTCOezg2sQ_82twQM",
            googleConversionTransactionLabel: "CRt_CJrxiGsQ_82twQM",
            optimiseCategory: "DE",
            optimiseType: .NonKids,
            emarsysMerchantId: "1B0C17B93E151CAA"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "NjG06NhkAPQvxmi7UFonQZnF6Aip1dv6",
            pushwooshAppId: "1B9C1-3FA16"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marken",
            productPathComponent: "p",
            productListPathComponent: "tag",
            cartPathComponent: "c/cart/view",
            searchPathComponent: "search",
            trendPathComponent: "trend",
            videosPathComponent: "videos",
            staticWebPagePathComponent: "d",
            wishlistPathComponent: "c/wishlist"
        )
        settingsConfiguration = SettingsConfiguration(
            howToMeasureText: .SettingsHowToMeasure
        )
        let versionComponent = Constants.isStagingEnv ? "api-test" : "api"
        apiBasePath = "https://\(versionComponent).showroom.de/ios/v2"
        
        if Constants.isStagingEnv {
            webPageURL = NSURL(string: "https://de.test.shwrm.net")!
        } else {
            webPageURL = NSURL(string: "https://www.showroom.de")!
        }
    }
}

final class ComConfiguration: Configuration {
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1193182446")!
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let settingsConfiguration: SettingsConfiguration
    let feedbackEmail = "ios@shwrm.com"
    let availableGenders: [Gender] = [.Female]
    let platformDescription = "showroom.com"
    let webPageURL: NSURL
    let currencyCode = "$"
    let locale = NSLocale(localeIdentifier: "en_US")
    
    init() {
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-15" : "UA-28549987-11",
            googleConversionId: "863441612",
            googleConversionAppStartLabel: "o5iqCMuwn20QzKXcmwM",
            googleConversionTransactionLabel: "u3kzCNewn20QzKXcmwM",
            optimiseCategory: "EU",
            optimiseType: .NonKids,
            emarsysMerchantId: "17A231B6D96E15F4"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "QAK7Asy2LsQ3O1huA5qzxP40zQEpMEhG",
            pushwooshAppId: "0F483-4A155"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "designers",
            productPathComponent: "p",
            productListPathComponent: "tag",
            cartPathComponent: "c/cart/view",
            searchPathComponent: "search",
            trendPathComponent: "trend",
            videosPathComponent: "videos",
            staticWebPagePathComponent: "d",
            wishlistPathComponent: "c/wishlist"
        )
        settingsConfiguration = SettingsConfiguration(
            howToMeasureText: nil
        )
        let versionComponent = Constants.isStagingEnv ? "api-test" : "api"
        apiBasePath = "https://\(versionComponent).shwrm.com/ios/v2"
        
        webPageURL = NSURL(string: "https://www.shwrm.com")!
    }

}

final class KidsConfiguration: Configuration {
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1193174056")!
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let settingsConfiguration: SettingsConfiguration
    let feedbackEmail = "ios@kids.showroom.pl"
    let availableGenders: [Gender] = [.Female]
    let platformDescription = "kids.showroom.pl"
    let webPageURL: NSURL
    let currencyCode = "PLN"
    let locale = NSLocale(localeIdentifier: "pl")
    
    init() {
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-14" : "UA-28549987-11",
            googleConversionId: "997811776",
            googleConversionAppStartLabel: "bVJtCPKamm0QwMzl2wM",
            googleConversionTransactionLabel: "mDSNCIvIhm0QwMzl2wM",
            optimiseCategory: "PL",
            optimiseType: .Kids,
            emarsysMerchantId: "10E41903ECB6DC9E"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "WoiOHvMAwav8LU82F/sctaWplz6jRbQh",
            pushwooshAppId: "835D9-CFACC"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marki",
            productPathComponent: "dziecko",
            productListPathComponent: "dzieci",
            cartPathComponent: "c/cart/view",
            searchPathComponent: "search",
            trendPathComponent: "trend",
            videosPathComponent: "videos",
            staticWebPagePathComponent: "d",
            wishlistPathComponent: "c/wishlist"
        )
        settingsConfiguration = SettingsConfiguration(
            howToMeasureText: .SettingsHowToMeasureKids
        )
        let versionComponent = Constants.isStagingEnv ? "api-kids-test" : "api-kids"
        apiBasePath = "https://\(versionComponent).showroom.pl/ios/v2"
        
        if Constants.isStagingEnv {
            webPageURL = NSURL(string: "https://kids.test.shwrm.net")!
        } else {
            webPageURL = NSURL(string: "https://kids.showroom.pl")!
        }
    }
    
}
