import UIKit
import Fabric
import Crashlytics
import XCGLogger
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let assembler = try! DiAssembler()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureDependencies()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        logInfo("Configuring main window")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = assembler.resolver.resolve(RootViewController.self)
        window?.makeKeyAndVisible()
        
        logInfo("Main window configured")
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
        return handleOpen(withURL: url)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        logInfo("Received continueUserActivity \(userActivity)")
        if let webPageUrl = userActivity.webpageURL where userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return handleOpen(withURL: webPageUrl)
        }
        return false
    }
    
    private func configureDependencies() {
        Logging.configure()
        
        if !Constants.isDebug {
            Fabric.with([Crashlytics.self])
        }
    }
}

extension AppDelegate: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        guard let deepLinkingHandler = window?.rootViewController as? DeepLinkingHandler else { return false }
        return deepLinkingHandler.handleOpen(withURL: url)
    }
}