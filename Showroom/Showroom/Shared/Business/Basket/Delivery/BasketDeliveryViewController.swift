import Foundation
import UIKit
import RxSwift

class BasketDeliveryViewController: UIViewController, BasketDeliveryViewDelegate {
    private let basketManager: BasketManager
    private var castView: BasketDeliveryView { return view as! BasketDeliveryView }
    private let disposeBag = DisposeBag()
    
    init(basketManager: BasketManager) {
        self.basketManager = basketManager
        super.init(nibName: nil, bundle: nil)
        title = tr(.BasketDeliveryTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BasketDeliveryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(with: basketManager.state.basket)
        castView.updateData(with: basketManager.state.deliveryCountry)
        castView.updateData(with: basketManager.state.deliveryCarrier)
        
        basketManager.state.basketObservable.subscribeNext { [weak self] basket in
            self?.castView.updateData(with: basket)
            }.addDisposableTo(disposeBag)
        basketManager.state.deliveryCountryObservable.subscribeNext { [weak self] deliveryCountry in
            self?.castView.updateData(with: deliveryCountry)
            }.addDisposableTo(disposeBag)
        basketManager.state.deliveryCarrierObservable.subscribeNext { [weak self] deliveryCarrier in
            self?.castView.updateData(with: deliveryCarrier)
            }.addDisposableTo(disposeBag)
        basketManager.state.validationStateObservable.subscribeNext { [weak self] validationState in
            self?.updateValidating(with: validationState)
        }.addDisposableTo(disposeBag)
    }
    
    func updateValidating(with validationState: BasketValidationState) {
        if validationState.validating {
            castView.changeSwitcherState(.Loading)
        } else {
            castView.changeSwitcherState(validationState.validated ? .Success : .Error)
        }
    }
    
    // MARK:- BasketDeliveryViewDelegate
    
    func deliveryViewDidTapOk(view: BasketDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .Close))
    }
    
    func deliveryViewDidTapCountry(view: BasketDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowCountrySelectionList))
    }
    
    func deliveryViewDidTapUpsOption(view: BasketDeliveryView) {
        logAnalyticsEvent(AnalyticsEventId.CartDeliveryMethodChanged(DeliveryType.UPS.rawValue))
        basketManager.state.deliveryCarrier = basketManager.state.basket?.deliveryInfo.carriers.find { $0.id == DeliveryType.UPS }
        basketManager.validate()
    }
    
    func deliveryViewDidTapRuchOption(view: BasketDeliveryView) {
        logAnalyticsEvent(AnalyticsEventId.CartDeliveryMethodChanged(DeliveryType.RUCH.rawValue))
        basketManager.state.deliveryCarrier = basketManager.state.basket?.deliveryInfo.carriers.find { $0.id == DeliveryType.RUCH }
        basketManager.validate()
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        basketManager.validate()
    }
}
