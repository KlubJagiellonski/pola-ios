import UIKit
import Fabric
import Crashlytics
import XCGLogger
import EmarsysPredictSDK

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