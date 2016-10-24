import Foundation
import UIKit

enum RateAppViewType {
    case AfterTime
    case AfterBuy
    
    private var description: String {
        switch self {
        case .AfterTime:
            return tr(.RateAppDescriptionAfterTime)
        case .AfterBuy:
            return tr(.RateAppDescriptionAfterBuy)
        }
    }
}

protocol RateAppViewControllerDelegate: class {
    func rateAppWantsDismiss(viewController: RateAppViewController)
}

final class RateAppViewController: UIViewController, AlertViewDelegate {
    private var castView: AlertView { return view as! AlertView }
    private let type: RateAppViewType
    private let manager: RateAppManager
    private weak var application: UIApplication?
    weak var delegate: RateAppViewControllerDelegate?
    
    init(with type: RateAppViewType, manager: RateAppManager, application: UIApplication) {
        self.type = type
        self.manager = manager
        self.application = application
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AlertView(title: tr(L10n.RateAppTitle), description: type.description, acceptButtonTitle: tr(L10n.RateAppRate))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK:- RateAppViewDelegate
    
    func alertViewDidTapAccept(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("rate"))
        
        manager.didSelectRateApp()
        if let appStoreURL = manager.appStoreURL {
            application?.openURL(appStoreURL)
        }
        delegate?.rateAppWantsDismiss(self)
    }
    
    func alertViewDidTapDecline(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("decline"))
        
        manager.didSelectDeclineRateApp()
        delegate?.rateAppWantsDismiss(self)
    }
    
    func alertViewDidTapRemind(view: AlertView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("later"))
        
        manager.didSelectRemindLater()
        delegate?.rateAppWantsDismiss(self)
    }
}
