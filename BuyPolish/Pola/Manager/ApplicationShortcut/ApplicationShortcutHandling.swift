import Foundation
import UIKit

protocol ApplicationShortcutHandling {
    func handleShortcutItem(_ item: UIApplicationShortcutItem, window: UIWindow?) -> Bool
}

final class ApplicationShortcutHandler: ApplicationShortcutHandling {
    private enum ShortcutType: String {
        case scanCode
        case writeCode
        case search
        case news

        static func fromShortcut(_ item: UIApplicationShortcutItem) -> ShortcutType? {
            guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
                return nil
            }

            var typeString = item.type
            typeString.removeFirst(bundleIdentifier.count + 1)

            return ShortcutType(rawValue: typeString)
        }
    }

    func handleShortcutItem(_ item: UIApplicationShortcutItem, window: UIWindow?) -> Bool {
        guard let type = ShortcutType.fromShortcut(item),
              let rootViewController = window?.rootViewController as? RootViewController else {
            return false
        }

        switch type {
        case .scanCode:
            rootViewController.showScanCodeView()
        case .writeCode:
            rootViewController.showWriteCodeView()
        case .search:
            rootViewController.showSearch()
        case .news:
            rootViewController.showNews()
        }

        return true
    }
}
