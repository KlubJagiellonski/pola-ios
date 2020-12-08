import AVFoundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DI.container.resolve(AnalyticsProvider.self)!.configure()
        applyAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        if ProcessInfo.processInfo.arguments.contains("--disableAnimations") {
            window?.layer.speed = 0.0
            UIView.setAnimationsEnabled(false)
        }

        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            _ = handleShortcutItem(shortcutItem)
        }

        return true
    }

    func applicationDidBecomeActive(_ app: UIApplication) {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            guard let rootViewController = window?.rootViewController else {
                return
            }
            let strings = R.string.localizable.self
            let alertVC = UIAlertController(title: strings.cameraPrivacyTitle(),
                                            message: strings.cameraPrivacyScanBarcodeDescription(),
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: strings.settings(),
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.openSettings(app: app)
                                            }))
            alertVC.addAction(UIAlertAction(title: strings.cancel(), style: .destructive))
            rootViewController.present(alertVC, animated: true, completion: nil)
        }
    }

    private func openSettings(app: UIApplication) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        app.open(settingsUrl)
    }

    func application(_: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }

    private func applyAppearance() {
        UINavigationBar.appearance().barTintColor = Theme.mediumBackgroundColor
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [.font: Theme.titleFont]
    }

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
