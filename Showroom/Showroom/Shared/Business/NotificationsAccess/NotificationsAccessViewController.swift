import Foundation
import UIKit

enum NotificationsAccessViewType {
    case AfterTime
    case AfterWishlist
    
    private var description: String {
        switch self {
        case .AfterTime:
            return tr(L10n.PushNotificationDescriptionAfterTime)
        case .AfterWishlist:
            return tr(L10n.PushNotificationDescriptionAfterWishlist)
        }
    }
}

protocol NotificationsAccessViewControllerDelegate: class {
    func notificationsAccessWantsDismiss(viewController: NotificationsAccessViewController)
}

final class NotificationsAccessViewController: UIViewController, NotificationsAccessViewDelegate {
    private var castView: NotificationsAccessView {
        return view as! NotificationsAccessView
    }
    private let type: NotificationsAccessViewType
    private let manager: NotificationsManager
    
    weak var delegate: NotificationsAccessViewControllerDelegate?
    
    init(with type: NotificationsAccessViewType, manager: NotificationsManager) {
        self.type = type
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NotificationsAccessView(withDescription: type.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK: - PushNotificationViewDelegate
    
    func notificationsAccessViewDidTapAllow(view: NotificationsAccessView) {
        manager.registerForRemoteNotificationsIfNeeded()
        delegate?.notificationsAccessWantsDismiss(self)
    }
    
    func notificationsAccessViewDidTapRemindLater(view: NotificationsAccessView) {
        manager.didSelectRemindLater()
        delegate?.notificationsAccessWantsDismiss(self)
    }
    
    func notificationsAccessViewDidTapDecline(view: NotificationsAccessView) {
        manager.didSelectDecline()
        delegate?.notificationsAccessWantsDismiss(self)
    }
}