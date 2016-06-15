import Foundation
import UIKit

class BasketCountryViewController: UIViewController, BasketCountryViewDelegate {
    private let basketManager: BasketManager
    private var castView: BasketCountryView { return view as! BasketCountryView }
    
    init(basketManager: BasketManager) {
        self.basketManager = basketManager
        super.init(nibName: nil, bundle: nil)
        
        title = tr(.BasketDeliveryDeliveryCountryTitle)
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
        castView.updateData(with: createSampleData())
    }
    
    // MARK:- BasketCountryViewDelegate
    
    func countryView(view: BasketCountryView, didSelectCountryAtIndex index: Int) {
        // TODO: change model
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
}

// TODO: remove when we will have api

extension BasketCountryViewController {
    func createSampleData() -> [String] {
        return [
            "ARABIA SAUDYJSKA",
            "ARGENTYNA",
            "AUSTRALIA",
            "AUSTRA",
            "BAHRAIN",
            "BELGIA",
            "BIAŁORUŚ",
            "BRAZYLIA",
            "NIEMCY",
            "POLSA",
            "STANY ZJEDNOCZONE",
            "WYBRZEŻE KOŚCI SŁONIOWEJ"
        ]
    }
}
