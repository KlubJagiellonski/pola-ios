import AVFoundation
import FirebaseMessaging
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var notificationProvider: NotificationProvider?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let analyticsProvider = DI.container.resolve(AnalyticsProvider.self)!
        analyticsProvider.configure()
        applyAppearance()

        let notificationProvider = DI.container.resolve(NotificationProvider.self)!
        notificationProvider.register(in: application)
        self.notificationProvider = notificationProvider

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController(analyticsProvider: analyticsProvider, notificationProvider: notificationProvider)
        window?.backgroundColor = R.color.backgroundWindowColor()
        window?.makeKeyAndVisible()

        if ProcessInfo.processInfo.arguments.contains("--disableAnimations") {
            window?.layer.speed = 0.0
            UIView.setAnimationsEnabled(false)
        }

        if ProcessInfo.processInfo.arguments.contains("--enableDarkMode") {
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .dark
            }
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
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [.font: Theme.titleFont]
    }

    private func handleShortcutItem(_ item: UIApplicationShortcutItem) -> Bool {
        DI.container.resolve(ApplicationShortcutHandling.self)!.handleShortcutItem(item, window: window)
    }
}
