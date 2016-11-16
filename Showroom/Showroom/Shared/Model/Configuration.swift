import Foundation

struct EmarsysConfiguration {
    let pushPassword: String
    let pushwooshAppId: String
}

struct BraintreeConfiguration {
    let payPalUrlScheme: String
}

struct AnalyticsConfiguration {
    let googleTrackingId: String
    let googleConversionId: String
    let googleConversionAppStartLabel: String
    let googleConversionTransactionLabel: String
    let optimiseApiKey: String
    let optimiseMerchantId: Int
    let optimiseTrackInstallProductId: Int
    let optimiseTrackSaleProductId: Int
    let optimiseTrackRegistrationProductId: Int
    let emarsysMerchantId: String
}

struct DeepLinkConfiguration {
    let brandPathComponent: String
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
            optimiseApiKey: "72933403-B469-41FD-B6E4-635B5B44584F",
            optimiseMerchantId: 990079,
            optimiseTrackInstallProductId: 28575,
            optimiseTrackSaleProductId: 28577,
            optimiseTrackRegistrationProductId: 28576,
            emarsysMerchantId: "13CE3A05D54F66DD"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v",
            pushwooshAppId: "63A3E-B6CDA"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marki"
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
            optimiseApiKey: "72933403-B469-41FD-B6E4-635B5B44584F",
            optimiseMerchantId: 990079,
            optimiseTrackInstallProductId: 28575,
            optimiseTrackSaleProductId: 28577,
            optimiseTrackRegistrationProductId: 28576,
            emarsysMerchantId: "1B0C17B93E151CAA"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "NjG06NhkAPQvxmi7UFonQZnF6Aip1dv6",
            pushwooshAppId: "1B9C1-3FA16"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marken"
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
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1147114961")! // TODO:- change id
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let feedbackEmail = "ios@showroom.com" // TODO:- check if it is correct email
    let availableGenders: [Gender] = [.Female]
    let platformDescription = "showroom.com"
    let webPageURL: NSURL
    let currencyCode = "$"
    let locale = NSLocale(localeIdentifier: "en_US")
    
    init() {
        //TODO:- change all this values to com version
        
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-7" : "UA-28549987-11",
            googleConversionId: "1006448960",
            googleConversionAppStartLabel: "sTFZCITB7WoQwOL03wM",
            googleConversionTransactionLabel: "VJLuCLvF72oQwOL03wM",
            optimiseApiKey: "72933403-B469-41FD-B6E4-635B5B44584F",
            optimiseMerchantId: 990079,
            optimiseTrackInstallProductId: 28575,
            optimiseTrackSaleProductId: 28577,
            optimiseTrackRegistrationProductId: 28576,
            emarsysMerchantId: "13CE3A05D54F66DD"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v",
            pushwooshAppId: "63A3E-B6CDA"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marki"
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

final class KidsConfiguration: Configuration {
    let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id1147114961")! // TODO:- change id
    let apiBasePath: String
    let analyticsConfiguration: AnalyticsConfiguration
    let emarsysConfiguration: EmarsysConfiguration
    let deepLinkConfiguration: DeepLinkConfiguration
    let feedbackEmail = "ios@showroom.com" // TODO:- change
    let availableGenders: [Gender] = [.Female] // TODO: check it
    let platformDescription = "kids.showroom.com"
    let webPageURL: NSURL
    let currencyCode = "PLN"
    let locale = NSLocale(localeIdentifier: "pl")
    
    init() {
        //TODO:- change all this values to kids version
        
        analyticsConfiguration = AnalyticsConfiguration(
            googleTrackingId: Constants.isAppStore ? "UA-28549987-7" : "UA-28549987-11",
            googleConversionId: "1006448960",
            googleConversionAppStartLabel: "sTFZCITB7WoQwOL03wM",
            googleConversionTransactionLabel: "VJLuCLvF72oQwOL03wM",
            optimiseApiKey: "72933403-B469-41FD-B6E4-635B5B44584F",
            optimiseMerchantId: 990079,
            optimiseTrackInstallProductId: 28575,
            optimiseTrackSaleProductId: 28577,
            optimiseTrackRegistrationProductId: 28576,
            emarsysMerchantId: "13CE3A05D54F66DD"
        )
        emarsysConfiguration = EmarsysConfiguration(
            pushPassword: "tkmQP+f3p3ArdsbRcTTfBGpmXawqjo+v",
            pushwooshAppId: "63A3E-B6CDA"
        )
        deepLinkConfiguration = DeepLinkConfiguration(
            brandPathComponent: "marki"
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
