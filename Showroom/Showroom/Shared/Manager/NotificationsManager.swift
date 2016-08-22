import Foundation
import EmarsysPushSDK

protocol NotificationsManagerDelegate: class {
    func notificationManager(manager: NotificationsManager, didReceiveUrl url: NSURL)
}

final class NotificationsManager {
    private let lastNotificationIdKey = "last_notification_id"
    
    private let api: ApiService
    private let application: UIApplication
    private(set) var userAlreadyAskedForNotificationPermission: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userAlreadyAskedForNotificationPermission") }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userAlreadyAskedForNotificationPermission") }
    }
    var isRegistered: Bool {
        return application.isRegisteredForRemoteNotifications()
    }
    private let pushWooshManager = PushNotificationManager.pushManager()
    private let pushWooshManagerDelegateHandler = PushWooshManagerDelegateHandler()
    private var lastNotificationId: String? {
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: lastNotificationIdKey)
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(lastNotificationIdKey) as? String
        }
    }
    weak var delegate: NotificationsManagerDelegate?
    
    init(with api: ApiService, and application: UIApplication) {
        self.api = api
        self.application = application
        
        pushWooshManagerDelegateHandler.manager = self
        pushWooshManager.delegate = pushWooshManagerDelegateHandler
        
        EmarsysManager.setApplicationID(NSBundle.pushwooshAppId)
        EmarsysManager.setApplicationPassword(Constants.emarsysPushPassword)
        EmarsysManager.setCustomerHWID(pushWooshManager.getHWID())
    }
    
    func applicationDidFinishLaunching(withLaunchOptions launchOptions: [NSObject: AnyObject]?) {
        EmarsysManager.appLaunch()
        pushWooshManager.handlePushReceived(launchOptions)
        pushWooshManager.sendAppOpen()
        
        if isRegistered && !userAlreadyAskedForNotificationPermission {
            userAlreadyAskedForNotificationPermission = true
        }
        
        guard userAlreadyAskedForNotificationPermission else { return }
        registerForRemoteNotifications()
    }
    
    /*
    * Returns true if `registerForRemoteNotifications` called. False if it is not needed (already registered)
    */
    func registerForRemoteNotificationsIfNeeded() -> Bool {
        guard !isRegistered else {
            return false
        }
        registerForRemoteNotifications()
        userAlreadyAskedForNotificationPermission = true
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
    }
    
    func didReceiveRemoteNotification(userInfo userInfo: [NSObject : AnyObject]) {
        pushWooshManager.handlePushReceived(userInfo)
    }
    
    func didFailToRegisterForRemoteNotifications(with error: NSError) {
        logError("Cannot register for remote notifications \(error)")
        
        pushWooshManager.handlePushRegistrationFailure(error)
    }
    
    func takeNotificationId() -> String? {
        let lastNotificationId = self.lastNotificationId
        logInfo("Taking last notification id \(lastNotificationId)")
        self.lastNotificationId = nil
        return lastNotificationId
    }
    
    private func didReceive(url url: NSURL) {
        delegate?.notificationManager(self, didReceiveUrl: url)
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
        
        if let link = customData["link"] as? String, let url = NSURL(string: link), let httpsUrl = url.changeToHTTPSchemeIfNeeded() {
            notificationLink = link
            logInfo("Retrieved link \(link)")
            manager?.didReceive(url: httpsUrl)
        }
        
        if let id = customData["notification_id"] as? String {
            notificationId = Int(id)
            logInfo("Retrieved notificationId \(id)")
            manager?.lastNotificationId = id
        } else {
            manager?.lastNotificationId = nil
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