import KVNProgress
import UIKit

final class RootViewController: UITabBarController {
    private let scanCodeViewController: ScanCodeViewController
    private let analytics: AnalyticsHelper
    private let notificationProvider: NotificationProvider

    private enum TabOrder: Int, CaseIterable {
        case scan = 0
        case search
        case news
    }

    init(analyticsProvider: AnalyticsProvider,
         notificationProvider: NotificationProvider) {
        analytics = AnalyticsHelper(provider: analyticsProvider)
        scanCodeViewController = DI.container.resolve(ScanCodeViewController.self)!
        self.notificationProvider = notificationProvider
        super.init(nibName: nil, bundle: nil)

        let strings = R.string.localizable.self
        viewControllers = TabOrder
            .allCases
            .map { order in
                let vc: UIViewController
                switch order {
                case .scan:
                    vc = scanCodeViewController
                    vc.tabBarItem = UITabBarItem(title: strings.mainTabScanner(),
                                                 imageSystemName: "iphone")
                case .search:
                    vc = WebViewController(url: "https://pola-app.pl/m/search", ignoreSafeArea: false)
                    vc.tabBarItem = UITabBarItem(title: strings.mainTabSearch(),
                                                 imageSystemName: "magnifyingglass")
                case .news:
                    vc = WebViewController(url: "https://pola-app.pl/m/blog", ignoreSafeArea: false)
                    vc.tabBarItem = UITabBarItem(title: strings.mainTabNews(),
                                                 imageSystemName: "newspaper")
                }
                vc.tabBarItem.tag = order.rawValue
                return vc
            }

        let config = KVNProgressConfiguration.default()
        config?.stopColor = R.color.clearColor()
        config?.errorColor = R.color.clearColor()
        config?.statusColor = R.color.clearColor()
        config?.successColor = R.color.clearColor()
        config?.backgroundTintColor = R.color.strongBackgroundColor()
        config?.circleFillBackgroundColor = R.color.strongBackgroundColor()
        config?.circleStrokeForegroundColor = R.color.clearColor()

        KVNProgress.setConfiguration(config)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showScanCodeView() {
        switchToScanCodeViewController()
        scanCodeViewController.showScanCodeView()
    }

    func showWriteCodeView() {
        switchToScanCodeViewController()
        scanCodeViewController.showWriteCodeView()
    }

    private func switchToScanCodeViewController() {
        selectedIndex = TabOrder.scan.rawValue
    }

    func showSearch() {
        selectedIndex = TabOrder.search.rawValue
    }

    func showNews() {
        selectedIndex = TabOrder.news.rawValue
    }

    override func tabBar(_: UITabBar, didSelect item: UITabBarItem) {
        requestNotifictionAuthorizationIfNeeded(selectedTab: item)
        trackTabChanged(item: item)
    }

    private func requestNotifictionAuthorizationIfNeeded(selectedTab: UITabBarItem) {
        guard TabOrder(rawValue: selectedTab.tag) == .news else {
            return
        }
        notificationProvider.requestAuthorization()
    }

    private func trackTabChanged(item: UITabBarItem) {
        let tab = TabOrder(rawValue: item.tag).map { order -> AnalyticsMainTab in
            switch order {
            case .scan:
                return .scanner
            case .search:
                return .search
            case .news:
                return .news
            }
        }
        guard let tab = tab else {
            return
        }
        analytics.tabChanged(tab)
    }
}
