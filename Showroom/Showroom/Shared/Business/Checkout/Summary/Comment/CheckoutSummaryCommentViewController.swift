import Foundation
import UIKit

protocol CheckoutSummaryCommentViewControllerDelegate: class {
    func checkoutSummaryCommentWantsDismiss(viewController: CheckoutSummaryCommentViewController)
    func checkoutSummaryCommentWantsSaveAndDimsiss(viewController: CheckoutSummaryCommentViewController)
}

class CheckoutSummaryCommentViewController: UIViewController, CheckoutSummaryCommentViewDelegate {
    private let resolver: DiResolver
    private var castView: CheckoutSummaryCommentView { return view as! CheckoutSummaryCommentView }
    
    weak var delegate: CheckoutSummaryCommentViewControllerDelegate?
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryCommentView()
        castView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    // MARK: - CheckoutSummaryCommentViewDelegate
    
    func checkoutSummaryCommentViewDidTapClose() {
        delegate?.checkoutSummaryCommentWantsDismiss(self)
    }
    
    func checkoutSummaryCommentViewDidTapSave() {
        delegate?.checkoutSummaryCommentWantsSaveAndDimsiss(self)
    }
}
