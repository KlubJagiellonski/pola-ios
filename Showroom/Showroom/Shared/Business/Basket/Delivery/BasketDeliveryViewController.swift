import Foundation
import UIKit

class BasketDeliveryViewController: UIViewController, BasketDeliveryViewDelegate {
    private let basketManager: BasketManager
    private var castView: BasketDeliveryView { return view as! BasketDeliveryView }
    
    init(basketManager: BasketManager) {
        self.basketManager = basketManager
        super.init(nibName: nil, bundle: nil)
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
    }
    
    // MARK:- BasketDeliveryViewDelegate
    
    func deliveryViewDidTapOk(view: BasketDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .Close))
    }
    
    func deliveryViewDidTapCountry(view: BasketDeliveryView) {
        
    }
    
    func deliveryViewDidTapUpsOption(view: BasketDeliveryView) {
        
    }
    
    func deliveryViewDidTapRuchOption(view: BasketDeliveryView) {
        
    }
}
