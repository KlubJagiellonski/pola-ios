import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private(set) lazy var resolver: ResolverType = {
        return try! DiAssembler().resolver
    }()
    
    private lazy var applicationManager: ApplicationManager = { [unowned self]in
        let applicationManager = self.resolver.resolve(ApplicationManager.self)!
        applicationManager.delegate = self
        return applicationManager
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        applicationManager.didLaunch(withLaunchOptions: launchOptions)
        
        logInfo("Configuring main window")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = resolver.resolve(RootViewController.self)
        window?.makeKeyAndVisible()
        
        logInfo("Main window configured")
        
        applicationManager.didAddMainWindow(withLaunchOptions: launchOptions)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return applicationManager.didReceiveOpen(with: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        return applicationManager.didReceiveContinueActivity(with: userActivity)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        applicationManager.didRegisterUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        applicationManager.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        applicationManager.didFailToRegisterForRemoteNotifications(withError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        applicationManager.didReceiveRemoteNotification(withUserInfo: userInfo)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        applicationManager.willEnterForeground()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        applicationManager.didBecomeActive()
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(applicationManager.performAction(forItem: shortcutItem))
    }
}

extension AppDelegate: ApplicationManagerDelegate {
    func applicationManager(manager: ApplicationManager, didReceiveUrl url: NSURL) -> Bool {
        guard let deepLinkingHandler = window?.rootViewController as? DeepLinkingHandler else { return false }
        return deepLinkingHandler.handleOpen(withURL: url)
    }
    
    func applicationManager(manager: ApplicationManager, didReceiveShortcutEvent identifier: ShortcutIdentifier) {
        let rootViewController = window?.rootViewController as! RootViewController
        rootViewController.handleQuickActionShortcut(identifier)
    }
}
