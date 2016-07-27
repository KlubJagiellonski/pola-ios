import Foundation
import GoogleAnalytics

func logAnalyticsShowScreen(screenId: AnalyticsScreenId) {
    Analytics.sharedInstance.sendScreenViewEvent(screenId)
}

func logAnalyticsEvent(eventId: AnalyticsEventId) {
    Analytics.sharedInstance.setEvent(eventId)
}

enum AnalyticsScreenId: String {
    case Onboarding = "Onboarding"
    case Start = "Start"
    case Login = "Login"
    case Register = "Register"
    case Dashboard = "Dashboard"
    case Search = "Search"
    case Basket = "Basket"
    case Wishlist = "Wishlist"
    case Settings = "Settings"
    case ProductList = "ProductList"
    case ProductDetails = "ProductDetails"
    case ProductSizeChart = "ProductSizeChart"
    case Brand = "Brand"
    case BrandDescription = "BrandDescription"
    case Trend = "Trend"
    case Filter = "Filter"
    case SearchProducts = "SearchProducts"
    case CheckoutDelivery = "CheckoutDelivery"
    case CheckoutDeliveryEditAddress = "CheckoutDeliveryEditAddress"
    case CheckoutKioskSelection = "CheckoutKioskSelection"
    case CheckoutSummary = "CheckoutSummary"
    case CheckoutSuccess = "CheckoutSuccess"
    case CheckoutError = "CheckoutError"
    case UserData = "UserData"
    case OrdersHistory = "OrdersHistory"
    case HowToMeasure = "HowToMeasure"
    case Policy = "Policy"
    case FAQ = "FAQ"
    case Rules = "Rules"
    case Contact = "Contact"
}

enum AnalyticsEventId: RawRepresentable {
    //todo for testing purpose, remove when we will have real events
    case Test(Int)
    case Test1
    
    typealias RawValue = AnalyticsEvent
    var rawValue: RawValue {
        switch self {
        case .Test(let value):
            return AnalyticsEvent(category: "test", action: "test", label: "test", value: value)
        case .Test1:
            return AnalyticsEvent(category: "test1", action: "test1", label: "test1", value: nil)
        }
    }
    init?(rawValue: RawValue) {
        logError("Not supported")
        return nil
    }
}

struct AnalyticsEvent {
    let category: String
    let action: String
    let label: String
    let value: Int?
    
    private var analyticsData: [NSObject: AnyObject] {
        return GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject : AnyObject]
    }
}

final class Analytics {
    static let sharedInstance = Analytics()
    
    private let tracker: GAITracker
    
    init() {
        let gai = GAI.sharedInstance()
        gai.logger.logLevel = Constants.isDebug ? GAILogLevel.Verbose : GAILogLevel.Error
        self.tracker = gai.trackerWithTrackingId(Constants.googleAnalyticsTrackingId)
    }
    
    func sendScreenViewEvent(screenId: AnalyticsScreenId) {
        tracker.set(kGAIScreenName, value: screenId.rawValue)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func setEvent(eventId: AnalyticsEventId) {
        tracker.send(eventId.rawValue.analyticsData)
    }
}