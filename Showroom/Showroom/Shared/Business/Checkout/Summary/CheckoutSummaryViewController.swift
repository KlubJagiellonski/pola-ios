import UIKit

class CheckoutSummaryViewController: UIViewController {
    private let manager: BasketManager
    private var castView: CheckoutSummaryView { return view as! CheckoutSummaryView }
    private let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.updateData(with: manager.state.basket)
    }
}