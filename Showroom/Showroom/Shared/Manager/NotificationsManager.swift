import Foundation
import EmarsysPushSDK

protocol NotificationsManagerDelegate: class {
    func notificationManager(manager: NotificationsManager, didReceiveUrl url: NSURL)
}

final class NotificationsManager {
    private let api: ApiService
    private let application: UIApplication
    private var userAlreadyAskedForNotificationPermission: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userAlreadyAskedForNotificationPermission") }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userAlreadyAskedForNotificationPermission") }
    }
    var isRegistered: Bool {
        return application.isRegisteredForRemoteNotifications()
    }
    private let pushWooshManager = PushNotificationManager.pushManager()
    private let pushWooshManagerDelegateHandler = PushWooshManagerDelegateHandler()
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
        
        handleEmarsysRemoteNotification(withUserInfo: userInfo)
    }
    
    func handleEmarsysRemoteNotification(withUserInfo userInfo: [NSObject: AnyObject]) {
        var customString:String!
        if let theString = PushNotificationManager.pushManager().getCustomPushData(userInfo) {
            customString = theString
        }
        if (customString != "") && (customString != nil) {
            let text = customString.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(text!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                print(jsonData)
                let sid = jsonData["sid"] as! String
                EmarsysManager.messageOpen(sid)
            } catch {
                logError("Couldn't get notificaiton sid for emarsys \(error)")
            }
        }
    }
    
    func didFailToRegisterForRemoteNotifications(with error: NSError) {
        logError("Cannot register for remote notifications \(error)")
        
        pushWooshManager.handlePushRegistrationFailure(error)
    }
    
    private func didReceive(url url: NSURL) {
        delegate?.notificationManager(self, didReceiveUrl: url)
    }
}

final class PushWooshManagerDelegateHandler: NSObject, PushNotificationDelegate {
    private weak var manager: NotificationsManager?
    
    func onPushAccepted(pushManager: PushNotificationManager!, withNotification pushNotification: [NSObject : AnyObject]!, onStart: Bool) {
        logInfo("Pushwoosh onPushAccepted: \(pushNotification) \(onStart)")
        guard let link = pushNotification["link"] as? String, let url = NSURL(string: link), let httpsUrl = url.changeToHTTPSchemeIfNeeded() else {
            return
        }
        manager?.didReceive(url: httpsUrl)
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
}