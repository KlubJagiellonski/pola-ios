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

final class RateAppViewController: UIViewController, RateAppViewDelegate {
    private var castView: RateAppView { return view as! RateAppView }
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
        view = RateAppView(withDescription: type.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK:- RateAppViewDelegate
    
    func rateAppDidTapRate(view: RateAppView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("rate"))
        
        manager.didSelectRateApp()
        if let appStoreUrl = NSURL(string: Constants.appStoreUrl) {
            application?.openURL(appStoreUrl)
        }
        delegate?.rateAppWantsDismiss(self)
    }
    
    func rateAppDidTapDecline(view: RateAppView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("decline"))
        
        manager.didSelectDeclineRateApp()
        delegate?.rateAppWantsDismiss(self)
    }
    
    func rateAppDidTapRemindLater(view: RateAppView) {
        logAnalyticsEvent(AnalyticsEventId.ModalRateUs("later"))
        
        manager.didSelectRemindLater()
        delegate?.rateAppWantsDismiss(self)
    }
}