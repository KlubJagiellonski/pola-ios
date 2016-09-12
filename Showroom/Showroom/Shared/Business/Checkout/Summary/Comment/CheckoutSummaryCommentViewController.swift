import Foundation
import UIKit

protocol CheckoutSummaryCommentViewControllerDelegate: class {
    func checkoutSummaryCommentWantsDismiss(viewController: CheckoutSummaryCommentViewController)
    func checkoutSummaryCommentWantsSaveAndDimsiss(viewController: CheckoutSummaryCommentViewController)
}

class CheckoutSummaryCommentViewController: UIViewController, CheckoutSummaryCommentViewDelegate {
    private let resolver: DiResolver
    private var castView: CheckoutSummaryCommentView { return view as! CheckoutSummaryCommentView }
    
    let index: Int
    var comment: String?
    
    weak var delegate: CheckoutSummaryCommentViewControllerDelegate?
    
    init(resolver: DiResolver, comment: String?, index: Int) {
        self.resolver = resolver
        self.index = index
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryCommentView(comment: comment)
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
    
    func checkoutSummaryCommentViewDidTapClose(view: CheckoutSummaryCommentView) {
        logInfo("Checkout summary view did tap close")
        delegate?.checkoutSummaryCommentWantsDismiss(self)
    }
    
    func checkoutSummaryCommentViewDidTapSave(view: CheckoutSummaryCommentView) {
        logInfo("Checkout summary comment view did tap save")
        comment = view.comment
        delegate?.checkoutSummaryCommentWantsSaveAndDimsiss(self)
    }
}
