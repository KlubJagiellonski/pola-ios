import Foundation
import UIKit

protocol UpdateAppViewControllerDelegate: class {
    func updateAppWantsDismiss(viewController: UpdateAppViewController)
}

final class UpdateAppViewController: UIViewController, AlertViewDelegate {
    private var castView: AlertView { return view as! AlertView }
    private let manager: VersionManager
    private weak var application: UIApplication?
    weak var delegate: UpdateAppViewControllerDelegate?
    
    init(manager: VersionManager, application: UIApplication) {
        self.manager = manager
        self.application = application
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AlertView(title: tr(L10n.UpdateAppTitle), description: tr(L10n.UpdateAppDescription), acceptButtonTitle: tr(L10n.UpdateAppUpdate))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK:- AlertViewDelegate
    
    func alertViewDidTapAccept(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalUpdate("update"))
        
        manager.didSelectUpdate()
        if let appStoreUrl = NSURL(string: Constants.appStoreUrl) {
            application?.openURL(appStoreUrl)
        }
        delegate?.updateAppWantsDismiss(self)
    }
    
    func alertViewDidTapDecline(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalUpdate("decline"))
        
        manager.didSelectDecline()
        delegate?.updateAppWantsDismiss(self)
    }
    
    func alertViewDidTapRemind(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalUpdate("later"))
        
        manager.didSelectRemindLater()
        delegate?.updateAppWantsDismiss(self)
    }
}
