import Foundation
import UIKit

extension SearchContentType {
    static func from(mainSearchItem: SearchItem) -> SearchContentType{
        guard let branches = mainSearchItem.branches else { return .Normal }
        for branch in branches {
            if branch.branches != nil {
                return .BoldTree
            }
        }
        return .Normal
    }
}

class SearchContentNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private let mainSearchItem: SearchItem
    private let navigationDelegateHandler = CommonNavigationControllerDelegateHandler(hideNavigationBarForFirstView: true)
    
    init(with resolver: DiResolver, mainSearchItem: SearchItem) {
        self.resolver = resolver
        self.mainSearchItem = mainSearchItem
        super.init(nibName: nil, bundle: nil)
        
        delegate = navigationDelegateHandler
        navigationBar.applyWhiteStyle()
        
        setNavigationBarHidden(true, animated: false)
        viewControllers = [createContentViewController(with: mainSearchItem, type: SearchContentType.from(mainSearchItem))]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createContentViewController(with searchItem: SearchItem, type: SearchContentType) -> SearchContentViewController {
        let viewController = resolver.resolve(SearchContentViewController.self, arguments: (searchItem, type))
        viewController.resetBackTitle(tr(.SearchBack))
        return viewController
    }
    
    //MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let searchItemEvent = event as? ShowSearchItemEvent {
            if searchItemEvent.searchItem.branches == nil || searchItemEvent.isMainItem {
                guard let link = searchItemEvent.searchItem.link else {
                    logError("It shouldn't be possible to click on search element where link doesn't exist \(searchItemEvent.searchItem)")
                    return true
                }
                logAnalyticsEvent(AnalyticsEventId.SearchMenuClick(searchItemEvent.searchItem.link ?? ""))
                sendNavigationEvent(ShowItemForLinkEvent(link: link, title: searchItemEvent.searchItem.name, productDetailsFromType: nil, transitionImageTag: nil))
            } else {
                logAnalyticsEvent(AnalyticsEventId.SearchMenuTreeClick(searchItemEvent.searchItem.name))
                let viewController = createContentViewController(with: searchItemEvent.searchItem, type: .Tree)
                pushViewController(viewController, animated: true)
            }
            return true
        }
        return false
    }
}
