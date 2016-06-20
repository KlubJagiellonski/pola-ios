import UIKit

class CheckoutDeliveryViewController: UIViewController {

    let resolver: DiResolver
    var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CheckoutDeliveryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
