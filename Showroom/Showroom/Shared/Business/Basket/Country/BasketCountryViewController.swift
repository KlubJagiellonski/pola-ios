import Foundation
import UIKit
import RxSwift

class BasketCountryViewController: UIViewController, BasketCountryViewDelegate {
    private let basketManager: BasketManager
    private var castView: BasketCountryView { return view as! BasketCountryView }
    private let disposeBag = DisposeBag()
    private var firstLayoutSubviewsPassed = false
    
    init(basketManager: BasketManager) {
        self.basketManager = basketManager
        super.init(nibName: nil, bundle: nil)
        
        title = tr(.BasketDeliveryDeliveryCountryTitle)
        
        basketManager.state.basketObservable.subscribeNext(castView.updateData).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BasketCountryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
        castView.updateData(with: basketManager.state.basket)
        castView.selectedIndex = basketManager.state.basket?.deliveryInfo.availableCountries.indexOf { $0.id == basketManager.state.deliveryCountry?.id }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.moveToSelectedIndex()
        }
    }
    
    // MARK:- BasketCountryViewDelegate
    
    func countryView(view: BasketCountryView, didSelectCountryAtIndex index: Int) {
        let country = basketManager.state.basket?.deliveryInfo.availableCountries[safe: index]
        logInfo("Did select country at index \(index) \(country)")
        basketManager.state.deliveryCountry = country
        basketManager.validate()
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
}
