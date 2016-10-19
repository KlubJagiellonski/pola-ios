import Foundation
import GoogleAnalytics
import FBSDKCoreKit
import Crashlytics

func logAnalyticsAppStart() {
    Analytics.sharedInstance.sendAppStartEvent()
}

func logAnalyticsAppStartConversion(platform: Platform) {
    Analytics.sharedInstance.sendAppStartConversion(with: platform)
}

func logAnalyticsRegistration() {
    Analytics.sharedInstance.sendRegistrationEvent()
}

func logAnalyticsShowScreen(screenId: AnalyticsScreenId) {
    Analytics.sharedInstance.sendScreenViewEvent(screenId)
}

func logAnalyticsEvent(eventId: AnalyticsEventId) {
    Analytics.sharedInstance.sendEvent(eventId)
}

func logAnalyticsTransactionEvent(with payment: PaymentResult, products: [BasketProduct], platform: Platform) {
    Analytics.sharedInstance.sendAnalyticsTransactionEvent(with: payment, products: products, platform: platform)
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
    case Video = "Video"
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
    case SearchMainMenuClick(String)
    case SearchMenuTreeClick(String)
    case SearchMenuClick(String)
    case Search(String, Bool)
    case CartDiscountSubmitted(String)
    case CartProductDeleted(ObjectId)
    case CartQuantityChanged(ObjectId)
    case CartCountryChanged(String)
    case CartDeliveryMethodChanged(ObjectId)
    case CartGoToCheckoutClicked(Money)
    case WishlistProductClicked(ObjectId)
    case WishlistProductDeleted(ObjectId)
    case ProfileWebViewLinkClicked(String)
    case ProfileSocialMediaClicked(String) // fb/insta
    case ProfileLoginClicked
    case ProfileRegisterClicked
    case ProfileGenderChoice(String)
    case ProfileLogoutClicked
    case ProfileNotifications
    case ListBrandDetails(ObjectId)
    case ListNextPage
    case ListProductClicked(ObjectId)
    case ListAddToWishlist(ObjectId, Money)
    case ListFilterSubmit
    case ListFilterIconClicked
    case ListFilterChanged(FilterId)
    case ProductOpen(ObjectId, Money)
    case ProductClose(ObjectId)
    case ProductAddToWishlist(ObjectId, Money)
    case ProductRemoveFromWishlist(ObjectId)
    case ProductShare(ObjectId)
    case ProductSwitchPicture(ObjectId)
    case ProductZoomIn(ObjectId)
    case ProductShowDetails(ObjectId)
    case ProductSizeTableShown(ObjectId)
    case ProductOtherDesignerProductsClicked(ObjectId)
    case ProductChangeColorClicked(ObjectId)
    case ProductChangeSizeClicked(ObjectId)
    case ProductAddToCartClicked(ObjectId, String, Money)
    case ProductSwitchedWithLeftSwipe(String) // category/trend/designer
    case ProductSwitchedWithRightSwipe(String) // category/trend/designer
    case LoginFacebookClicked
    case LoginClicked
    case RegisterFacebookClicked
    case RegisterClicked(Bool)
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
    case CheckoutSummaryPaymentStatus(Bool, ObjectId)
    case ApplicationNotification(String?, Int?)
    case ApplicationLaunch(Int)
    case ModalRateUs(String)
    case ModalPush(String)
    case ModalUpdate(String)
    case QuickAction(String)
    case VideoLaunch(ObjectId)
    case VideoFirstSlideLoaded(ObjectId, Int)
    case VideoSegmentWatched(ObjectId, Int)
    case VideoPause(ObjectId)
    case VideoPlay(ObjectId)
    case VideoSwipeLeft(String) //video, product, image
    case VideoSwipeRight(String) //video, product, image
    case VideoClose(ObjectId)
    case VideoProductAddedToWishlist(ObjectId)
    case VideoProductPhotoTapped(ObjectId)
    case VideoProductInfoButtonTapped(ObjectId)
    case VideoSummaryNextButton(ObjectId)
    case VideoSummaryPrevButton(ObjectId)
    case VideoSummaryPlay(ObjectId)
    case VideoSummaryAutoPlay(ObjectId)
    case VideoSummaryWatchAgain(ObjectId)
    case VideoSummaryLinkClick(String)
    
    typealias RawValue = [AnalyticsEvent]
    var rawValue: RawValue {
        switch self {
        case .OnboardingNotificationClicked:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "notifications_button_click", label: nil, value: nil)]
        case .OnboardingNotificationAllow:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "notifications_popup", label: nil, value: 1)]
        case .OnboardingNotificationDisallow:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "notifications_popup", label: nil, value: 0)]
        case .OnboardingGenderChoice(let gender):
            return [GoogleAnalyticsEvent(category: "onboarding", action: "gender_choice", label: gender, value: nil)]
        case .OnboardingLoginClicked:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "login_click", label: nil, value: nil)]
        case .OnboardingRegisterClicked:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "register_click", label: nil, value: nil)]
        case .OnboardingNotificationSkip:
            return [GoogleAnalyticsEvent(category: "onboarding", action: "notifications_skip", label: nil, value: nil)]
        case .DashboardContentPromoClicked(let link, let index):
            return [GoogleAnalyticsEvent(category: "home", action: "home_banner_click", label: link, value: index)]
        case .DashboardRecommendationClicked(let link, let index):
            return [GoogleAnalyticsEvent(category: "home", action: "suggested_click", label: link, value: index)]
        case SearchMainMenuClick(let label):
            return [GoogleAnalyticsEvent(category: "browse", action: "main_menu_click", label: label, value: nil)]
        case SearchMenuTreeClick(let label):
            return [GoogleAnalyticsEvent(category: "browse", action: "tree_menu_click", label: label, value: nil)]
        case SearchMenuClick(let link):
            return [GoogleAnalyticsEvent(category: "browse", action: "menu_click", label: link, value: nil)]
        case Search(let query, let isChanged):
            return [GoogleAnalyticsEvent(category: "browse", action: "search", label: query, value: isChanged ? 1 : 0)]
        case CartDiscountSubmitted(let coupon):
            return [GoogleAnalyticsEvent(category: "cart", action: "coupon_submit", label: coupon, value: nil)]
        case CartProductDeleted(let id):
            return [GoogleAnalyticsEvent(category: "cart", action: "product_deleted", label: String(id), value: nil)]
        case CartQuantityChanged(let id):
            return [GoogleAnalyticsEvent(category: "cart", action: "quantity_changed", label: String(id), value: nil)]
        case CartCountryChanged(let countryId):
            return [GoogleAnalyticsEvent(category: "cart", action: "country_changed", label: countryId, value: nil)]
        case CartDeliveryMethodChanged(let id):
            return [GoogleAnalyticsEvent(category: "cart", action: "delivery_changed", label: String(id), value: nil)]
        case CartGoToCheckoutClicked(let cartValue):
            return [GoogleAnalyticsEvent(category: "cart", action: "go_to_checkout", label: String(cartValue.amount), value: nil)]
        case WishlistProductClicked(let id):
            return [GoogleAnalyticsEvent(category: "wishlist", action: "product_click", label: String(id), value: nil)]
        case WishlistProductDeleted(let id):
            return [GoogleAnalyticsEvent(category: "wishlist", action: "product_deleted", label: String(id), value: nil)]
        case ProfileWebViewLinkClicked(let link):
            return [GoogleAnalyticsEvent(category: "profile", action: "webview_click", label: link, value: nil)]
        case ProfileSocialMediaClicked(let type):
            return [GoogleAnalyticsEvent(category: "profile", action: "socialmedia_click", label: type, value: nil)]
        case ProfileLoginClicked:
            return [GoogleAnalyticsEvent(category: "profile", action: "login_click", label: nil, value: nil)]
        case ProfileRegisterClicked:
            return [GoogleAnalyticsEvent(category: "profile", action: "register_click", label: nil, value: nil)]
        case ProfileGenderChoice(let gender):
            return [GoogleAnalyticsEvent(category: "profile", action: "gender_choice", label: gender, value: nil)]
        case ProfileLogoutClicked:
            return [GoogleAnalyticsEvent(category: "profile", action: "logout", label: nil, value: nil)]
        case ProfileNotifications:
            return [GoogleAnalyticsEvent(category: "profile", action: "ask_notifications", label: nil, value: nil)]
        case ListBrandDetails(let brandId):
            return [GoogleAnalyticsEvent(category: "listing", action: "designer_details", label: String(brandId), value: nil)]
        case ListNextPage():
            return [GoogleAnalyticsEvent(category: "listing", action: "list_scroll", label: nil, value: nil)]
        case ListProductClicked(let id):
            return [GoogleAnalyticsEvent(category: "listing", action: "product_click", label: String(id), value: nil)]
        case ListAddToWishlist(let id, let value):
            let facebookParams = [
                FBSDKAppEventParameterNameContentID: NSNumber(integer: id),
                FBSDKAppEventParameterNameContentType: "product",
                FBSDKAppEventParameterNameCurrency: value.currency.eanValue
            ]
            return [
                GoogleAnalyticsEvent(category: "listing", action: "add_to_wishlist", label: String(id), value: nil),
                FacebookAnalyticsEvent(id: FBSDKAppEventNameAddedToWishlist, params: facebookParams, valueToSum: NSNumber(double: value.amount))
            ]
        case ListFilterSubmit:
            return [GoogleAnalyticsEvent(category: "listing", action: "filter_submit", label: nil, value: nil)]
        case ListFilterIconClicked:
            return [GoogleAnalyticsEvent(category: "listing", action: "filter_click", label: nil, value: nil)]
        case ListFilterChanged(let filterId):
            return [GoogleAnalyticsEvent(category: "listing", action: "filter_change", label: filterId, value: nil)]
        case ProductClose(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "close", label: String(id), value: nil)]
        case ProductOpen(let id, let value):
            let facebookParams = [
                FBSDKAppEventParameterNameContentID: NSNumber(integer: id),
                FBSDKAppEventParameterNameContentType: "product",
                FBSDKAppEventParameterNameCurrency: value.currency.eanValue
            ]
            return [
                FacebookAnalyticsEvent(id: FBSDKAppEventNameViewedContent, params: facebookParams, valueToSum: value.amount)
            ]
        case ProductAddToWishlist(let id, let value):
            let facebookParams = [
                FBSDKAppEventParameterNameContentID: NSNumber(integer: id),
                FBSDKAppEventParameterNameContentType: "product",
                FBSDKAppEventParameterNameCurrency: value.currency.eanValue
            ]
            return [
                GoogleAnalyticsEvent(category: "product", action: "add_to_wishlist", label: String(id), value: nil),
                FacebookAnalyticsEvent(id: FBSDKAppEventNameAddedToWishlist, params: facebookParams, valueToSum: NSNumber(double: value.amount))
            ]
        case ProductRemoveFromWishlist(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "remove_from_wishlist", label: String(id), value: nil)]
        case ProductShare(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "share", label: String(id), value: nil)]
        case ProductSwitchPicture(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "switch_picture", label: String(id), value: nil)]
        case ProductZoomIn(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "zoom", label: String(id), value: nil)]
        case ProductShowDetails(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "show_details", label: String(id), value: nil)]
        case ProductSizeTableShown(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "size_table", label: String(id), value: nil)]
        case ProductOtherDesignerProductsClicked(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "other_products", label: String(id), value: nil)]
        case ProductChangeColorClicked(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "change_color_click", label: String(id), value: nil)]
        case ProductChangeSizeClicked(let id):
            return [GoogleAnalyticsEvent(category: "product", action: "change_size_click", label: String(id), value: nil)]
        case ProductAddToCartClicked(let id, let viewType, let value):
            let facebookParams = [
                FBSDKAppEventParameterNameContentID: NSNumber(integer: id),
                FBSDKAppEventParameterNameContentType: "product",
                FBSDKAppEventParameterNameCurrency: value.currency.eanValue
            ]
            return [
                GoogleAnalyticsEvent(category: "product", action: "add_to_cart", label: viewType, value: nil),
                FacebookAnalyticsEvent(id: FBSDKAppEventNameAddedToCart, params: facebookParams, valueToSum: NSNumber(double: value.amount))
            ]
        case ProductSwitchedWithLeftSwipe(let type):
            return [GoogleAnalyticsEvent(category: "product", action: "switch_product_left", label: type, value: nil)]
        case ProductSwitchedWithRightSwipe(let type):
            return [GoogleAnalyticsEvent(category: "product", action: "switch_product_right", label: type, value: nil)]
        case LoginFacebookClicked:
            return [GoogleAnalyticsEvent(category: "login", action: "facebook_button_click", label: nil, value: nil)]
        case LoginClicked:
            return [GoogleAnalyticsEvent(category: "login", action: "login_button_click", label: nil, value: nil)]
        case RegisterFacebookClicked:
            return [GoogleAnalyticsEvent(category: "register", action: "facebook_button_click", label: nil, value: nil)]
        case RegisterClicked(let newsletterEnabled):
            return [GoogleAnalyticsEvent(category: "register", action: "register_button_click", label: newsletterEnabled ? "true" : "false", value: nil)]
        case CheckoutCancelClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "cancel_click", label: nil, value: nil)]
        case CheckoutAddressClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "address_click", label: nil, value: nil)]
        case CheckoutAddNewAddressClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "add_new_address", label: nil, value: nil)]
        case CheckoutChosePOPClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "pop_button_click", label: nil, value: nil)]
        case CheckoutNextClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "next_button_click", label: nil, value: nil)]
        case CheckoutPOPClicked:
            return [GoogleAnalyticsEvent(category: "checkout", action: "pop_choice", label: nil, value: nil)]
        case CheckoutPOPAddressChanged:
            return [GoogleAnalyticsEvent(category: "checkout", action: "pop_address_changed", label: nil, value: nil)]
        case CheckoutSummaryAddNoteClicked:
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "add_note_click", label: nil, value: nil)]
        case CheckoutSummaryDeleteNoteClicked:
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "delete_note_click", label: nil, value: nil)]
        case CheckoutSummaryEditNoteClicked:
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "edit_note_click", label: nil, value: nil)]
        case CheckoutSummaryPaymentMethodClicked(let methodId):
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "payment_method_click", label: String(methodId), value: nil)]
        case CheckoutSummaryFinishButtonClicked:
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "finish_button_click", label: nil, value: nil)]
        case CheckoutSummaryPaymentStatus(let success, _):
            return [GoogleAnalyticsEvent(category: "checkout_summary", action: "payment_status", label: success ? "true" : "false", value: nil)]
        case ApplicationNotification(let link, _):
            return [GoogleAnalyticsEvent(category: "application", action: "notification", label: link, value: nil)]
        case ApplicationLaunch(let launchCounter):
            return [GoogleAnalyticsEvent(category: "application", action: "launch", label: String(launchCounter), value: launchCounter)]
        case ModalRateUs(let buttonType):
            return [GoogleAnalyticsEvent(category: "modal", action: "rate_us", label: buttonType, value: nil)]
        case ModalPush(let buttonType):
            return [GoogleAnalyticsEvent(category: "modal", action: "push", label: buttonType, value: nil)]
        case ModalUpdate(let buttonType):
            return [GoogleAnalyticsEvent(category: "modal", action: "new_version", label: buttonType, value: nil)]
        case QuickAction(let action):
            return [GoogleAnalyticsEvent(category: "quickaction", action: "click", label: action, value: nil)]
        case VideoLaunch(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "launch", label: String(videoId), value: nil)]
        case VideoFirstSlideLoaded(let videoId, let loadingTime):
            return [GoogleAnalyticsEvent(category: "video", action: "first_slide_loaded", label: String(videoId), value: loadingTime)]
        case VideoSegmentWatched(let videoId, let segmentTime):
            return [GoogleAnalyticsEvent(category: "video", action: "segment_watched", label: String(videoId), value: segmentTime)]
        case VideoPause(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "pause", label: String(videoId), value: nil)]
        case VideoPlay(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "play", label: String(videoId), value: nil)]
        case VideoSwipeLeft(let typeOfSlide):
            return [GoogleAnalyticsEvent(category: "video", action: "swipe_left", label: typeOfSlide, value: nil)]
        case VideoSwipeRight(let typeOfSlide):
            return [GoogleAnalyticsEvent(category: "video", action: "swipe_right", label: typeOfSlide, value: nil)]
        case VideoClose(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "close", label: String(videoId), value: nil)]
        case VideoProductAddedToWishlist(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "product_wishlist", label: String(videoId), value: nil)]
        case VideoProductPhotoTapped(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "product_photo", label: String(videoId), value: nil)]
        case VideoProductInfoButtonTapped(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "product_details", label: String(videoId), value: nil)]
        case VideoSummaryNextButton(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "summary_next", label: String(videoId), value: nil)]
        case VideoSummaryPrevButton(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "summary_prev", label: String(videoId), value: nil)]
        case VideoSummaryPlay(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "summary_play", label: String(videoId), value: nil)]
        case VideoSummaryAutoPlay(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "summary_autoplay", label: String(videoId), value: nil)]
        case VideoSummaryWatchAgain(let videoId):
            return [GoogleAnalyticsEvent(category: "video", action: "summary_watch_again", label: String(videoId), value: nil)]
        case VideoSummaryLinkClick(let link):
            return [GoogleAnalyticsEvent(category: "video", action: "link_click", label: link, value: nil)]
        }
    }
    init?(rawValue: RawValue) {
        logError("Not supported")
        return nil
    }
}

protocol AnalyticsEvent { }

struct GoogleAnalyticsEvent: AnalyticsEvent {
    let category: String
    let action: String
    let label: String?
    let value: Int?
    
    private var analyticsData: [NSObject: AnyObject] {
        return GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject: AnyObject]
    }
}

struct FacebookAnalyticsEvent: AnalyticsEvent {
    let id: String
    let params: [NSObject: AnyObject]?
    let valueToSum: NSNumber?
}

final class Analytics {
    static let sharedInstance = Analytics()
    
    private var tracker: GAITracker?
    private let optimiseManager = OMGSDK.sharedManager()
    private let affilationKey = "affilation_key"
    
    var userId: String? {
        set { tracker?.set(kGAIUserId, value: newValue) }
        get { return tracker?.get(kGAIUserId) }
    }
    
    var affilation: String? {
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: affilationKey) }
        get { return NSUserDefaults.standardUserDefaults().objectForKey(affilationKey) as? String }
    }
    
    init() {
        GAI.sharedInstance().logger.logLevel = Constants.isDebug ? GAILogLevel.Info : GAILogLevel.Error
        
        optimiseManager.setApplicationKey(Constants.optimiseApiKey)
        optimiseManager.setMID(Constants.optimiseMerchantId)
    }
    
    func didChange(platform platform: Platform) {
        self.tracker = GAI.sharedInstance().trackerWithTrackingId(platform.googleAnalyticsTrackingId)
    }
    
    func sendScreenViewEvent(screenId: AnalyticsScreenId) {
        tracker?.set(kGAIScreenName, value: screenId.rawValue)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder.build() as [NSObject: AnyObject])
        
        Crashlytics.sharedInstance().setObjectValue(screenId.rawValue, forKey: "current_screen")
    }
    
    func sendEvent(eventId: AnalyticsEventId) {
        for event in eventId.rawValue {
            switch event {
            case let googleEvent as GoogleAnalyticsEvent:
                tracker?.send(googleEvent.analyticsData)
            case let facebookEvent as FacebookAnalyticsEvent:
                FBSDKAppEvents.logEvent(facebookEvent.id, valueToSum: facebookEvent.valueToSum, parameters: facebookEvent.params, accessToken: FBSDKAccessToken.currentAccessToken())
            default: continue
            }
        }
        
    }
    
    func sendAnalyticsTransactionEvent(with payment: PaymentResult, products: [BasketProduct], platform: Platform) {
        let moneyFormatter = MathMoneyFormatter(showGroupingSeparator: false)
        let paymentAmountString = moneyFormatter.stringForObjectValue(payment.amount.doubleValue) ?? String(payment.amount.doubleValue)
        
        // sending addword converson
        ACTConversionReporter.reportWithConversionID(platform.conversionId, label: platform.conversionTransactionLabel, value: paymentAmountString, isRepeatable: true)
        
        // sending optimise
        for product in products {
            optimiseManager.trackEventWhereAppID(String(payment.orderId), pid: Constants.optimiseTrackSaleProductId, status: paymentAmountString, currency: payment.currency, ex1: "Sale", ex2: String(product.id), ex3: nil, ex4: nil, ex5: nil)
        }
        
        // sending facebook
        for product in products {
            let facebookParams = [
                FBSDKAppEventParameterNameContentID: NSNumber(integer: product.id),
                FBSDKAppEventParameterNameContentType: "product"
            ]
            FBSDKAppEvents.logPurchase(product.price.amount, currency: product.price.currency.eanValue, parameters: facebookParams, accessToken: FBSDKAccessToken.currentAccessToken())
        }
        
        // sending google analytics
        let transaction = GAIDictionaryBuilder.createTransactionWithId(
            String(payment.orderId),
            affiliation: affilation ?? "",
            revenue: payment.amount,
            tax: payment.taxAmount,
            shipping: payment.shippingAmount,
            currencyCode: payment.currency
        ).build()
        tracker?.send(transaction as [NSObject: AnyObject])
        
        for product in products {
            let item = GAIDictionaryBuilder.createItemWithTransactionId(
                String(payment.orderId),
                name: product.name,
                sku: String(product.id),
                category: nil,
                price: product.price.money.0,
                quantity: product.amount,
                currencyCode: payment.currency
            ).build()
            tracker?.send(item as [NSObject: AnyObject])
        }
        
        affilation = nil
    }
    
    func sendAppStartEvent() {
        optimiseManager.trackInstallWhereAppID(nil, pid: Constants.optimiseTrackInstallProductId, deepLink: false, ex1: "Install", ex2: nil, ex3: nil, ex4: nil, ex5: nil)
    }
    
    func sendAppStartConversion(with platform: Platform) {
        ACTConversionReporter.reportWithConversionID(platform.conversionId, label: platform.conversionAppStartLabel, value: "0.00", isRepeatable: false)
    }
    
    func sendRegistrationEvent() {
        optimiseManager.trackEventWhereAppID(nil, pid: Constants.optimiseTrackRegistrationProductId, status: "1", currency: nil, ex1: "Registration", ex2: nil, ex3: nil, ex4: nil, ex5: nil)
    }
}

extension Platform {
    private var conversionId: String {
        switch self {
        case .German:
            return Constants.deConversionId
        case .Polish:
            return Constants.conversionId
        }
    }
    
    private var conversionAppStartLabel: String {
        switch self {
        case .German:
            return Constants.deConversionAppStartLabel
        case .Polish:
            return Constants.conversionAppStartLabel
        }
    }
    
    private var conversionTransactionLabel: String {
        switch self {
        case .German:
            return Constants.deConversionTransactionLabel
        case .Polish:
            return Constants.conversionTransactionLabel
        }
    }
    
    private var googleAnalyticsTrackingId: String {
        switch self {
        case .German:
            return Constants.deGoogleAnalyticsTrackingId
        case .Polish:
            return Constants.googleAnalyticsTrackingId
        }
    }
}