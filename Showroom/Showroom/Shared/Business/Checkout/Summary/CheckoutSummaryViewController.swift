import UIKit

class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
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
        castView.delegate = self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.updateData(with: manager.state.basket)
    }
    
    // MARK: - CheckoutSummaryViewDelegate
    
    func checkoutSummaryViewDidTapAddComment(brand: BasketBrand) {
        logInfo("Add comment to " + brand.name)
    }
    
    func checkoutSummaryViewDidTapEditComment(brand: BasketBrand) {
        logInfo("Edit comment for " + brand.name)
    }
    
    func checkoutSummaryViewDidTapDeleteComment(brand: BasketBrand) {
        logInfo("Delete comment from " + brand.name)
    }
}