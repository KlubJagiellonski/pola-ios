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

final class NotificationsAccessViewController: UIViewController, AlertViewDelegate {
    private var castView: AlertView {
        return view as! AlertView
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
        view = AlertView(title: tr(L10n.PushNotificationTitle), description: type.description, question: tr(L10n.PushNotificationQuestion), acceptButtonTitle: tr(L10n.PushNotificationAllow))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK: - PushNotificationViewDelegate
    
    func alertViewDidTapAccept(view: AlertView) {
        manager.registerForRemoteNotificationsIfNeeded()
        delegate?.notificationsAccessWantsDismiss(self)
    }
    
    func alertViewDidTapDecline(view: AlertView) {
        manager.didSelectDecline()
        delegate?.notificationsAccessWantsDismiss(self)
    }
    
    func alertViewDidTapRemind(view: AlertView) {
        manager.didSelectRemindLater()
        delegate?.notificationsAccessWantsDismiss(self)
    }
}