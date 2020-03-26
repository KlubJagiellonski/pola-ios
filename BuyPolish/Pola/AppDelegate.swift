import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        AnalyticsHelper.configure()
        applyAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        if ProcessInfo.processInfo.arguments.contains("--disableAnimations") {
            window?.layer.speed = 0.0
            UIView.setAnimationsEnabled(false)
        }
        
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
                _ = handleShortcutItem(shortcutItem)
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            let strings = R.string.localizable.self
            let alertView = UIAlertView(title: strings.cameraPrivacyTitle(),
                                        message: strings.cameraPrivacyScanBarcodeDescription(),
                                        delegate: self,
                                        cancelButtonTitle: strings.cancel(),
                                        otherButtonTitles: strings.settings())
            alertView.show()
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
    
    private func applyAppearance() {
        UINavigationBar.appearance().barTintColor = Theme.mediumBackgroundColor
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [.font : Theme.titleFont]

    }
    
    @available(iOS 9.0, *)
    private func handleShortcutItem(_ item: UIApplicationShortcutItem) -> Bool {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier,
            let rootViewController = window?.rootViewController as? RootViewController else {
            return false
        }
        let scanType = "\(bundleIdentifier).ScanCode"
        let writeType = "\(bundleIdentifier).WriteCode"
        switch item.type {
        case scanType:
            rootViewController.showScanCodeView()
            return true
        case writeType:
            rootViewController.showWriteCodeView()
            return true
        default:
            return false
        }

    }
}

extension AppDelegate: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        guard alertView.cancelButtonIndex != buttonIndex,
        let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.openURL(settingsUrl)
    }
}
