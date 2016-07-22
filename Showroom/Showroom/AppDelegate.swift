import UIKit
import Fabric
import Crashlytics
import XCGLogger
import EmarsysPredictSDK
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let assembler = try! DiAssembler()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureDependencies()
        
        logInfo("Configuring main window")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = assembler.resolver.resolve(RootViewController.self)
        window?.makeKeyAndVisible()
        
        logInfo("Main window configured")
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.absoluteString.hasPrefix("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        guard let deepLinkingHandler = window?.rootViewController as? DeepLinkingHandler else { return false }
        return deepLinkingHandler.handleOpen(withURL: url)
    }
    
    private func configureDependencies() {
        Logging.configure()
        
        if !Constants.isDebug {
            Fabric.with([Crashlytics.self])
        }
        
        let emarsysSession = EMSession.sharedSession()
        emarsysSession.merchantID = Constants.emarsysMerchantId
        emarsysSession.logLevel = Constants.isDebug ? .Debug : .Warning
    }
}