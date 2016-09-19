import Foundation
import EmarsysPushSDK
import RxSwift

protocol NotificationsManagerDelegate: class {
    func notificationManager(manager: NotificationsManager, didReceiveUrl url: NSURL)
}

final class NotificationsManager {
    private let userAlreadyAskedForNotificationPermissionKey = "userAlreadyAskedForNotificationPermission"
    private let alreadyShowedNotifcationsAccessViewKey = "alreadyShowedNotifcationsAccessView"
    private let dontShowNotificationsAccessViewKey = "dontShowNotificationsAccessViewKey"
    private let daysThreesholdForShowingView = 7
    private let initialDateKey = "initial_notifications_access_date"
    
    private let api: ApiService
    private let application: UIApplication
    private let disposeBag = DisposeBag()
    private let storage: KeyValueStorage
    
    let shouldShowInSettingsObservable = PublishSubject<Void>()
    
    /// Returns true if native alert for notifications access was preseted to the user.
    private var userAlreadyAskedForNotificationsPermission: Bool {
        get {
            return storage.load(forKey: userAlreadyAskedForNotificationPermissionKey) ?? false
        }
        set {
            logInfo("userAlreadyAskedForNotificationsPermission \(newValue)")
            storage.save(newValue, forKey: userAlreadyAskedForNotificationPermissionKey)
            shouldShowInSettingsObservable.onNext()
        }
    }
    
    /// Returns true if only notifications acces view was presented to the user.
    private var alreadyShowedNotifcationsAccessView: Bool {
        get {
            return storage.load(forKey: alreadyShowedNotifcationsAccessViewKey) ?? false
        }
        set {
            logInfo("alreadyShowedNotifcationsAccessView \(newValue)")
            storage.save(newValue, forKey: alreadyShowedNotifcationsAccessViewKey)
        }
    }
    
    /// Returns true if user don't want to be reminded about notifications access.
    private var dontShowNotificationsAccesView: Bool {
        get {
            return storage.load(forKey: dontShowNotificationsAccessViewKey) ?? false
        }
        set {
            logInfo("dontShowNotificationsAccesView \(newValue)")
            storage.save(newValue, forKey: dontShowNotificationsAccessViewKey)
        }
    }
    
    var isRegistered: Bool {
        return application.isRegisteredForRemoteNotifications()
    }
    private let pushWooshManager = PushNotificationManager.pushManager()
    private let pushWooshManagerDelegateHandler = PushWooshManagerDelegateHandler()

    private var initialDate: NSDate {
        get {
            let initialTimeInterval: NSTimeInterval? = storage.load(forKey: initialDateKey)
            if let timeInterval = initialTimeInterval {
                return NSDate(timeIntervalSince1970: timeInterval)
            } else {
                let initialDate = NSDate()
                storage.save(initialDate.timeIntervalSince1970, forKey: initialDateKey)
                return initialDate
            }
        }
        set {
            logInfo("initialDate \(newValue)")
            storage.save(newValue.timeIntervalSince1970, forKey: initialDateKey)
        }
    }
    var shouldShowInSettings: Bool {
        return !userAlreadyAskedForNotificationsPermission && !isRegistered
    }
    var shouldAskForRemoteNotifications: Bool {
        return !dontShowNotificationsAccesView
            && !userAlreadyAskedForNotificationsPermission
            && initialDate.numberOfDaysUntilDateTime(NSDate()) >= daysThreesholdForShowingView
    }
    var shouldShowNotificationsAccessViewFromWishlist: Bool {
        return !userAlreadyAskedForNotificationsPermission
            && !alreadyShowedNotifcationsAccessView
    }
    
    weak var delegate: NotificationsManagerDelegate?
    
    init(with api: ApiService, application: UIApplication, storage: KeyValueStorage) {
        self.api = api
        self.application = application
        self.storage = storage
        
        pushWooshManagerDelegateHandler.manager = self
        pushWooshManager.delegate = pushWooshManagerDelegateHandler
        
        EmarsysManager.setApplicationID(NSBundle.pushwooshAppId)
        EmarsysManager.setApplicationPassword(Constants.emarsysPushPassword)
        EmarsysManager.setCustomerHWID(pushWooshManager.getHWID())
    }
    
    func applicationDidFinishLaunching(withLaunchOptions launchOptions: [NSObject: AnyObject]?) {
        logInfo("Did finish launching with options")
        EmarsysManager.appLaunch()
        pushWooshManager.handlePushReceived(launchOptions)
        pushWooshManager.sendAppOpen()
        
        if isRegistered && !userAlreadyAskedForNotificationsPermission {
            userAlreadyAskedForNotificationsPermission = true
        }
    }
    
    /*
    * Returns true if `registerForRemoteNotifications` called. False if it is not needed (already registered)
    */
    func registerForRemoteNotificationsIfNeeded() -> Bool {
        logInfo("Registering for remote notification if needed")
        guard !isRegistered else {
            logInfo("Registered already")
            return false
        }
        registerForRemoteNotifications()
        userAlreadyAskedForNotificationsPermission = true
        return true
    }
    
    private func registerForRemoteNotifications() {
        logInfo("Registering for push notifications")
        
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        application.registerForRemoteNotifications()
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: NSData) {
        logInfo("Registered for remote notifications with success: \(deviceToken)")
        
        pushWooshManager.handlePushRegistration(deviceToken)
        EmarsysManager.pushAccepted(pushWooshManager.getPushToken())
        
        api.pushToken(with: PushTokenRequest(pushToken: pushWooshManager.getPushToken(), hardwareId: pushWooshManager.getHWID()))
            .subscribeNext { logInfo("Send push token with success") }
            .addDisposableTo(disposeBag)
    }
    
    func didReceiveRemoteNotification(userInfo userInfo: [NSObject : AnyObject]) {
        logInfo("Did receive remote notification \(userInfo)")
        pushWooshManager.handlePushReceived(userInfo)
    }
    
    func didFailToRegisterForRemoteNotifications(with error: NSError) {
        logError("Cannot register for remote notifications \(error)")
        
        pushWooshManager.handlePushRegistrationFailure(error)
    }
    
    private func didReceive(url url: NSURL) {
        logInfo("Did receive url \(url)")
        delegate?.notificationManager(self, didReceiveUrl: url)
    }
    
    func didShowNotificationsAccessView() {
        logInfo("Did show notifications access view")
        initialDate = NSDate()
        alreadyShowedNotifcationsAccessView = true
    }
    
    func didSelectDecline() {
        logInfo("Did select decline")
        dontShowNotificationsAccesView = true
    }
    
    func didSelectRemindLater() {
        logInfo("Did select remind later")
    }
}

final class PushWooshManagerDelegateHandler: NSObject, PushNotificationDelegate {
    private weak var manager: NotificationsManager?
    
    func onPushAccepted(pushManager: PushNotificationManager!, withNotification pushNotification: [NSObject : AnyObject]!, onStart: Bool) {
        logInfo("Pushwoosh onPushAccepted: \(pushNotification) \(onStart)")
        
        guard let customData = retrieveCustomData(fromNotificaiton: pushNotification, forManager: pushManager) else {
            return
        }
        
        var notificationLink: String?
        var notificationId: Int?
        
        if let sid = customData["sid"] as? String {
            logInfo("Sending message open with sid \(sid)")
            EmarsysManager.messageOpen(sid)
        }
        
        if let link = customData["link"] as? String, let url = NSURL(string: link), let httpsUrl = url.changeToHTTPSchemeIfNeeded() {
            notificationLink = link
            logInfo("Retrieved link \(link)")
            manager?.didReceive(url: httpsUrl)
        }
        
        if let id = customData["notification_id"] as? String {
            notificationId = Int(id)
            logInfo("Retrieved notificationId \(id)")
            Analytics.sharedInstance.affilation = id
        } else {
            Analytics.sharedInstance.affilation = nil
        }
        
        logAnalyticsEvent(AnalyticsEventId.ApplicationNotification(notificationLink, notificationId))
    }
    
    func onInAppClosed(code: String!) {
        logInfo("Pushwoosh onInAppClosed: \(code)")
    }
    
    func onInAppDisplayed(code: String!) {
        logInfo("Pushwoosh onInAppDisplayed \(code)")
    }
    
    func onTagsFailedToReceive(error: NSError!) {
        logInfo("Pushwoosh onTagsFailedToReceive \(error)")
    }
    
    func onTagsReceived(tags: [NSObject : AnyObject]!) {
        logInfo("Pushwoosh onTagsReceived \(tags)")
    }
    
    func onDidRegisterForRemoteNotificationsWithDeviceToken(token: String!) {
        logInfo("Pushwoosh onDidRegisterForRemoteNotifications")
    }
    
    func onDidFailToRegisterForRemoteNotificationsWithError(error: NSError!) {
        logInfo("Pushwoosh onDidFailToRegisterForRemoteNotificationsWithError \(error)")
    }
    
    private func retrieveCustomData(fromNotificaiton notification: [NSObject: AnyObject], forManager manager: PushNotificationManager) -> [String: AnyObject]? {
        guard let customString = manager.getCustomPushData(notification) where !customString.isEmpty else {
            logError("No custom push data")
            return nil
        }
        
        guard let customData = customString.dataUsingEncoding(NSUTF8StringEncoding) else {
            logError("Cannot convert to data")
            return nil
        }
        
        do {
            return try NSJSONSerialization.JSONObjectWithData(customData, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
        } catch {
            logError("Could not parse to json \(error)")
            return nil
        }
    }
}