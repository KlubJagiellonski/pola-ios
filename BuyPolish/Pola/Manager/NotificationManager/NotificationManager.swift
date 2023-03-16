import FirebaseMessaging
import Foundation
import UIKit

final class NotificationManager: NSObject, NotificationProvider {
    weak var application: UIApplication?
    func register(in application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        self.application = application
    }

    func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { [weak self] success, _ in
                if success {
                    DispatchQueue.main.async {
                        self?.authorizationGranted()
                    }
                }
        }
    }

    private func authorizationGranted() {
        application?.registerForRemoteNotifications()

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        completionHandler([[.alert, .badge, .sound]])
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive _: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
