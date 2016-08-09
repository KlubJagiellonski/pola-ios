import Foundation
import GoogleAnalytics

func logAnalyticsShowScreen(screenId: AnalyticsScreenId) {
    Analytics.sharedInstance.sendScreenViewEvent(screenId)
}

func logAnalyticsEvent(eventId: AnalyticsEventId) {
    Analytics.sharedInstance.sendEvent(eventId)
}

enum AnalyticsScreenId: String {
    case Onboarding = "Onboarding"
    case Start = "Start"
    case Login = "Login"
    case Register = "Register"
    case ResetPassword = "ResetPassword"
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
    case OnboardingNotificationClicked
    case OnboardingNotificationAllow
    case OnboardingNotificationDisallow
    case OnboardingNotificationSkip
    case OnboardingGenderChoice(String)
    case OnboardingLoginClicked
    case OnboardingRegisterClicked
    case DashboardContentPromoClicked(String, Int)
    case DashboardRecommendationClicked(String, Int)
    case SearchItemClick(String)
    case Search(String)
    case CartDiscountSubmitted(String)
    case CartProductDeleted(ObjectId)
    case CartQuantityChanged(ObjectId)
    case CartDeliveryMethodChanged(ObjectId)
    case CartGoToCheckoutClicked(Money)
    case WishlistProductClicked(ObjectId)
    case WishlistProductDeleted(ObjectId)
    case ProfileWebViewLinkClicked(String)
    case ProfileSocialMediaClicked(String) //fb/insta
    case ProfileLoginClicked
    case ProfileRegisterClicked
    case ProfileGenderChoice(String)
    case ProfileLogoutClicked
    case ListBrandDetails(ObjectId)
    case ListNextPage(String)
    case ListProductClicked(ObjectId)
    case ListAddToWishlist(ObjectId)
    case ListFilterSubmit(String)
    case ListFilterIconClicked(String)
    case ListFilterChanged(FilterId)
    case ProductClose(ObjectId)
    case ProductAddToWishlist(ObjectId)
    case ProductShare(ObjectId)
    case ProductSwitchPicture(ObjectId)
    case ProductZoomIn(ObjectId)
    case ProductShowDetails(ObjectId)
    case ProductSizeTableShown(ObjectId)
    case ProductOtherDesignerProductsClicked(ObjectId)
    case ProductChangeColorClicked(ObjectId)
    case ProductChangeSizeClicked(ObjectId)
    case ProductAddToCartClicked(ObjectId)
    case ProductSwitchedWithLeftSwipe(String) // category/trend/designer
    case ProductSwitchedWithRightSwipe(String) // category/trend/designer
    case LoginFacebookClicked
    case LoginClicked
    case CheckoutCancelClicked
    case CheckoutAddressClicked
    case CheckoutAddNewAddressClicked
    case CheckoutChosePOPClicked
    case CheckoutNextClicked
    case CheckoutPOPClicked
    case CheckoutPOPAddressChanged
    case CheckoutSummaryAddNoteClicked
    case CheckoutSummaryDeleteNoteClicked
    case CheckoutSummaryEditNoteClicked
    case CheckoutSummaryPaymentMethodClicked(ObjectId)
    case CheckoutSummaryFinishButtonClicked
    
    
    typealias RawValue = AnalyticsEvent
    var rawValue: RawValue {
        switch self {
        case .OnboardingNotificationClicked:
            return AnalyticsEvent(category: "onboarding", action: "notifications_button_click", label: nil, value: nil)
        case .OnboardingNotificationAllow:
            return AnalyticsEvent(category: "onboarding", action: "notifications_popup", label: nil, value: 1)
        case .OnboardingNotificationDisallow:
            return AnalyticsEvent(category: "onboarding", action: "notifications_popup", label: nil, value: 0)
        case .OnboardingGenderChoice(let gender):
            return AnalyticsEvent(category: "onboarding", action: "gender_choice", label: gender, value: nil)
        case .OnboardingLoginClicked:
            return AnalyticsEvent(category: "onboarding", action: "login_click", label: nil, value: nil)
        case .OnboardingRegisterClicked:
            return AnalyticsEvent(category: "onboarding", action: "register_click", label: nil, value: nil)
        case .DashboardContentPromoClicked(let link, let index):
            return AnalyticsEvent(category: "home", action: "home_banner_click", label: link, value: index)
        case .DashboardRecommendationClicked(let link, let index):
            return AnalyticsEvent(category: "home", action: "suggested_click", label: link, value: index)
        case SearchItemClick(let link):
            return AnalyticsEvent(category: "browse", action: "menu_click", label: link, value: nil)
        case Search(let query):
            return AnalyticsEvent(category: "browse", action: "search", label: query, value: nil)
        case CartDiscountSubmitted(let coupon):
            return AnalyticsEvent(category: "cart", action: "coupon_submit", label: coupon, value: nil)
        case CartProductDeleted(let id):
            return AnalyticsEvent(category: "cart", action: "product_deleted", label: nil, value: id)
        case CartQuantityChanged(let id):
            return AnalyticsEvent(category: "cart", action: "quantity_changed", label: nil, value: id)
        case CartDeliveryMethodChanged(let id):
            return AnalyticsEvent(category: "cart", action: "delivery_changed", label: nil, value: id)
        case CartGoToCheckoutClicked(let cartValue):
            return AnalyticsEvent(category: "cart", action: "go_to_checkout", label: nil, value: Int(cartValue.amount))
        case WishlistProductClicked(let id):
            return AnalyticsEvent(category: "wishlist", action: "product_click", label: nil, value: id)
        case WishlistProductDeleted(let id):
            return AnalyticsEvent(category: "wishlist", action: "product_deleted", label: nil, value: id)
        case ProfileWebViewLinkClicked(let link):
            return AnalyticsEvent(category: "profile", action: "webview_click", label: link, value: nil)
        case ProfileSocialMediaClicked(let type):
            return AnalyticsEvent(category: "profile", action: "socialmedia_click", label: type, value: nil)
        case ProfileLoginClicked:
            return AnalyticsEvent(category: "profile", action: "login_click", label: nil, value: nil)
        case ProfileRegisterClicked:
            return AnalyticsEvent(category: "profile", action: "register_click", label: nil, value: nil)
        case ProfileGenderChoice(let gender):
            return AnalyticsEvent(category: "profile", action: "gender_choice", label: gender, value: nil)
        case ProfileLogoutClicked:
            return AnalyticsEvent(category: "profile", action: "logout", label: nil, value: nil)
        case ListBrandDetails(let brandId):
            return AnalyticsEvent(category: "listing", action: "designer_details", label: nil, value: brandId)
        case ListNextPage(let link):
            return AnalyticsEvent(category: "listing", action: "list_scroll", label: link, value: nil)
        case ListProductClicked(let id):
            return AnalyticsEvent(category: "listing", action: "product_click", label: nil, value: id)
        case ListAddToWishlist(let id):
            return AnalyticsEvent(category: "listing", action: "add_to_wishlist", label: nil, value: id)
        case ListFilterSubmit(let link):
            return AnalyticsEvent(category: "listing", action: "filter_submit", label: link, value: nil)
        case ListFilterIconClicked(let link):
            return AnalyticsEvent(category: "listing", action: "filter_click", label: link, value: nil)
        case ListFilterChanged(let filterId):
            return AnalyticsEvent(category: "listing", action: "filter_change", label: filterId, value: nil)
        case ProductClose(let id):
            return AnalyticsEvent(category: "product", action: "close", label: nil, value: id)
        case ProductAddToWishlist(let id):
            return AnalyticsEvent(category: "product", action: "add_to_wishlist", label: nil, value: id)
        case ProductShare(let id):
            return AnalyticsEvent(category: "product", action: "share", label: nil, value: id)
        case ProductSwitchPicture(let id):
            return AnalyticsEvent(category: "product", action: "switch_picture", label: nil, value: id)
        case ProductZoomIn(let id):
            return AnalyticsEvent(category: "product", action: "zoom", label: nil, value: id)
        case ProductShowDetails(let id):
            return AnalyticsEvent(category: "product", action: "show_details", label: nil, value: id)
        case ProductSizeTableShown(let id):
            return AnalyticsEvent(category: "product", action: "size_table", label: nil, value: id)
        case ProductOtherDesignerProductsClicked(let id):
            return AnalyticsEvent(category: "product", action: "other_products", label: nil, value: id)
        case ProductChangeColorClicked(let id):
            return AnalyticsEvent(category: "product", action: "change_color_click", label: nil, value: id)
        case ProductChangeSizeClicked(let id):
            return AnalyticsEvent(category: "product", action: "change_size_click", label: nil, value: id)
        case ProductAddToCartClicked(let id):
            return AnalyticsEvent(category: "product", action: "add_to_cart", label: nil, value: id)
        case ProductSwitchedWithLeftSwipe(let type):
            return AnalyticsEvent(category: "product", action: "switch_product_left", label: type, value: nil)
        case ProductSwitchedWithRightSwipe(let type):
            return AnalyticsEvent(category: "product", action: "switch_product_right", label: type, value: nil)
        case LoginFacebookClicked:
            return AnalyticsEvent(category: "login", action: "facebook_button_click", label: nil, value: nil)
        case LoginClicked:
            return AnalyticsEvent(category: "login", action: "login_button_click", label: nil, value: nil)
        case CheckoutCancelClicked:
            return AnalyticsEvent(category: "checkout", action: "cancel_click", label: nil, value: nil)
        case CheckoutAddressClicked:
            return AnalyticsEvent(category: "checkout", action: "address_click", label: nil, value: nil)
        case CheckoutAddNewAddressClicked:
            return AnalyticsEvent(category: "checkout", action: "add_new_address", label: nil, value: nil)
        case CheckoutChosePOPClicked:
            return AnalyticsEvent(category: "checkout", action: "pop_button_click", label: nil, value: nil)
        case CheckoutNextClicked:
            return AnalyticsEvent(category: "checkout", action: "next_button_click", label: nil, value: nil)
        case CheckoutPOPClicked:
            return AnalyticsEvent(category: "checkout", action: "pop_choice", label: nil, value: nil)
        case CheckoutPOPAddressChanged:
            return AnalyticsEvent(category: "checkout", action: "pop_address_changed", label: nil, value: nil)
        case CheckoutSummaryAddNoteClicked:
            return AnalyticsEvent(category: "checkout_summary", action: "add_note_click", label: nil, value: nil)
        case CheckoutSummaryDeleteNoteClicked:
            return AnalyticsEvent(category: "checkout_summary", action: "delete_note_click", label: nil, value: nil)
        case CheckoutSummaryEditNoteClicked:
            return AnalyticsEvent(category: "checkout_summary", action: "edit_note_click", label: nil, value: nil)
        case CheckoutSummaryPaymentMethodClicked(let methodId):
            return AnalyticsEvent(category: "checkout_summary", action: "payment_method_click", label: nil, value: methodId)
        case CheckoutSummaryFinishButtonClicked:
            return AnalyticsEvent(category: "checkout_summary", action: "finish_button_click", label: nil, value: nil)
        default:
            fatalError("Not handled \(self)")
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
    let label: String?
    let value: Int?
    
    private var analyticsData: [NSObject: AnyObject] {
        return GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject : AnyObject]
    }
}

final class Analytics {
    static let sharedInstance = Analytics()
    
    private let tracker: GAITracker
    
    var userId: String? {
        set { tracker.set(kGAIUserId, value: newValue) }
        get { return tracker.get(kGAIUserId) }
    }
    
    init() {
        let gai = GAI.sharedInstance()
        gai.logger.logLevel = Constants.isDebug ? GAILogLevel.Info : GAILogLevel.Error
        self.tracker = gai.trackerWithTrackingId(Constants.googleAnalyticsTrackingId)
    }
    
    func sendScreenViewEvent(screenId: AnalyticsScreenId) {
        tracker.set(kGAIScreenName, value: screenId.rawValue)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func sendEvent(eventId: AnalyticsEventId) {
        tracker.send(eventId.rawValue.analyticsData)
    }
}