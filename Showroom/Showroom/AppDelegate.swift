import UIKit
import Fabric
import Crashlytics
import XCGLogger
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let assembler = try! DiAssembler()
    private lazy var userManager: UserManager = { [unowned self] in
        return self.assembler.resolver.resolve(UserManager.self)!
    }()
    private lazy var notificationsManager: NotificationsManager = { [unowned self] in
        let manager = self.assembler.resolver.resolve(NotificationsManager.self)!
        manager.delegate = self
        return manager
    }()
    
    private var quickActionManager: QuickActionManager!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureDependencies()
        quickActionManager = assembler.resolver.resolve(QuickActionManager.self)
        quickActionManager.delegate = self
        
        userManager.updateUser()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        logInfo("Configuring main window")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = assembler.resolver.resolve(RootViewController.self)
        window?.makeKeyAndVisible()
        
        logInfo("Main window configured")
        
        notificationsManager.applicationDidFinishLaunching(withLaunchOptions: launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        if let payUManager = assembler.resolver.resolve(PayUManager.self) where payUManager.handleOpen(withURL: url) {
            return true
        }
        logInfo("Received url \(url) with options: \(sourceApplication)")
        
        if let httpsUrl = url.changeToHTTPSchemeIfNeeded() {
            return handleOpen(withURL: httpsUrl)
        } else {
            return false
        }
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        logInfo("Received continueUserActivity \(userActivity)")
        if let webPageUrl = userActivity.webpageURL where userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return handleOpen(withURL: webPageUrl)
        }
        return false
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        notificationsManager.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        notificationsManager.didFailToRegisterForRemoteNotifications(with: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        notificationsManager.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        userManager.updateUser()
    }
    
    private func configureDependencies() {
        Logging.configure()
        
        if !Constants.isDebug {
            Fabric.with([Crashlytics.self])
        }
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(quickActionManager.handleShortcutItem(shortcutItem))
    }
}

extension AppDelegate: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        guard let deepLinkingHandler = window?.rootViewController as? DeepLinkingHandler else { return false }
        return deepLinkingHandler.handleOpen(withURL: url)
    }
}

extension AppDelegate: QuickActionManagerDelegate {
    func quickActionManager(manager: QuickActionManager, didTapShortcut shortcut: ShortcutIdentifier) {
        let rootViewController = window?.rootViewController as! RootViewController
        rootViewController.handleQuickActionShortcut(shortcut)
    }
}

extension AppDelegate: NotificationsManagerDelegate {
    func notificationManager(manager: NotificationsManager, didReceiveUrl url: NSURL) {
        handleOpen(withURL: url)
    }
}