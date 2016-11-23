import Foundation
import Fabric
import Crashlytics
import XCGLogger
import FBSDKCoreKit
import RxSwift
import CoreSpotlight

protocol ApplicationManagerDelegate: class {
    func applicationManager(manager: ApplicationManager, didReceiveShortcutEvent identifier: ShortcutIdentifier)
    func applicationManager(manager: ApplicationManager, didReceiveUrl url: NSURL) -> Bool
}

final class ApplicationManager {
    private let application: UIApplication
    private let configurationManager: ConfigurationManager
    private let storage: KeyValueStorage
    private let quickActionManager: QuickActionManager
    private let userManager: UserManager
    private let notificationsManager: NotificationsManager
    private let paymentManager: PaymentManager
    private let apiService: ApiService
    private let toastManager: ToastManager
    private let disposeBag = DisposeBag()
    
    weak var delegate: ApplicationManagerDelegate?
    
    init(application: UIApplication,
         configurationManager: ConfigurationManager,
         storage: KeyValueStorage,
         quickActionManager: QuickActionManager,
         userManager: UserManager,
         notificationsManager: NotificationsManager,
         paymentManager: PaymentManager,
         apiService: ApiService,
         toastManager: ToastManager) {
        self.application = application
        self.configurationManager = configurationManager
        self.storage = storage
        self.quickActionManager = quickActionManager
        self.userManager = userManager
        self.notificationsManager = notificationsManager
        self.paymentManager = paymentManager
        self.apiService = apiService
        self.toastManager = toastManager
        
        quickActionManager.delegate = self
        notificationsManager.delegate = self
        
        configurationManager.configurationObservable.subscribeNext { [unowned self] info in
            guard info.oldConfiguration == nil else { return }
            logAnalyticsAppStart()
            logAnalyticsEvent(AnalyticsEventId.ApplicationLaunch(self.incrementLaunchCount()))
            userManager.updateUser()
        }.addDisposableTo(disposeBag)
    }
    
    func didLaunch(withLaunchOptions launchOptions: [NSObject: AnyObject]?) {
        configurationManager.inititialize()
        
        Logging.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        BTAppSwitch.setReturnURLScheme(Constants.braintreePayPalUrlScheme)
    }
    
    func didAddMainWindow(withLaunchOptions launchOptions: [NSObject: AnyObject]?) {
        notificationsManager.didFinishAppLaunching(withLaunchOptions: launchOptions)
    }
    
    func didReceiveOpen(with url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        if paymentManager.currentPaymentHandler?.handleOpenURL(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        logInfo("Received url \(url) with options: \(sourceApplication)")
        
        return handleOpen(with: url)
    }
    
    func didReceiveContinueActivity(with userActivity: NSUserActivity) -> Bool {
        logInfo("Received continueUserActivity \(userActivity)")
        if let webPageUrl = userActivity.webpageURL where userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            logAnalyticsEvent(AnalyticsEventId.ContinuityFromWebBrowsing(webPageUrl.absoluteOrRelativeString))
            return delegate?.applicationManager(self, didReceiveUrl: webPageUrl) ?? false
        }
        if let itemUrl = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String, let linkURL = NSURL(string: itemUrl)
            where userActivity.activityType == CSSearchableItemActionType {
            logAnalyticsEvent(AnalyticsEventId.ContinuityFromSpotlightSearch(linkURL.absoluteOrRelativeString))
            return delegate?.applicationManager(self, didReceiveUrl: linkURL) ?? false
        }
        return false
    }
    
    func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings) {
        notificationsManager.didRegisterUserNotificationSettings(notificationSettings)
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: NSData) {
        notificationsManager.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func didFailToRegisterForRemoteNotifications(withError error: NSError) {
        notificationsManager.didFailToRegisterForRemoteNotifications(with: error)
    }
    
    func didReceiveRemoteNotification(withUserInfo userInfo: [NSObject : AnyObject]) {
        notificationsManager.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func willEnterForeground() {
        userManager.updateUser()
    }
    
    func didBecomeActive() {
        FBSDKAppEvents.activateApp()
        
        FBSDKAppLinkUtility.fetchDeferredAppLink { [weak self] url, error in
            if url != nil && error == nil {
                self?.handleOpen(with: url)
            } else {
                logInfo("Cannot fetch deferred app link \(url) \(error)")
            }
        }
        
        logInfo("app did become active")
    }
    
    func performAction(forItem shortcutItem: UIApplicationShortcutItem) -> Bool {
        logInfo("Perform action with item \(shortcutItem)")
        return quickActionManager.handleShortcutItem(shortcutItem)
    }
    
    private func incrementLaunchCount() -> Int {
        let launchCountKey = "launch_count"
        let count = (storage.load(forKey: launchCountKey) ?? 0) + 1
        storage.save(count, forKey: launchCountKey)
        return count
    }
    
    private func handleOpen(with url: NSURL) -> Bool {
        guard let configuration = configurationManager.configuration else {
            logError("Cannot open url. Configuration doesn't exist")
            return false
        }
        
        guard url.host == configuration.webPageURL.host else {
            logInfo("URL.host (\(url)) does not equal configuraion webPageURL host \(configuration.webPageURL)")
            toastManager.showMessage(tr(.DeepLinkingWrongPlatform))
            logAnalyticsEvent(AnalyticsEventId.DeepLinkWrongPlatform)
            return false
        }
        
        if let httpsUrl = url.changeToHTTPSchemeIfNeeded() {
            Analytics.sharedInstance.affilation = httpsUrl.retrieveUtmSource()
            return delegate?.applicationManager(self, didReceiveUrl: httpsUrl) ?? false
        } else {
            return false
        }
    }
}

extension ApplicationManager: QuickActionManagerDelegate {
    func quickActionManager(manager: QuickActionManager, didTapShortcut shortcut: ShortcutIdentifier) {
        logInfo("Did receive shortcut \(shortcut)")
        delegate?.applicationManager(self, didReceiveShortcutEvent: shortcut)
    }
}

extension ApplicationManager: NotificationsManagerDelegate {
    func notificationManager(manager: NotificationsManager, didReceiveUrl url: NSURL) {
        logInfo("Did receive url \(url)")
        handleOpen(with: url)
    }
}
