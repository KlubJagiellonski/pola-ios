import UIKit

final class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
    private let manager: BasketManager
    private let model: CheckoutModel
    private var castView: CheckoutSummaryView { return view as! CheckoutSummaryView }
    private let resolver: DiResolver
    private let commentAnimator = FormSheetAnimator()
    
    init(resolver: DiResolver, model: CheckoutModel) {
        self.resolver = resolver
        self.manager = resolver.resolve(BasketManager.self)
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryView()
        castView.delegate = self;
        commentAnimator.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let discountCode = manager.state.basket?.discountErrors == nil ? manager.state.discountCode : nil
        castView.updateData(with: manager.state.basket, carrier: manager.state.deliveryCarrier, discountCode: discountCode, comments: model.state.comments)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutSummary)
    }
    
    private func showCommentModal(forComment comment: String?, at index: Int)
    {
        let viewController = resolver.resolve(CheckoutSummaryCommentViewController.self, arguments: (comment, index))
        viewController.delegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 264)
        commentAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    // MARK: - CheckoutSummaryViewDelegate
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int) {
        logInfo("Add comment")
        showCommentModal(forComment: nil, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int) {
        logInfo("Edit comment")
        let editedComment = model.comment(at: index)
        showCommentModal(forComment: editedComment, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int) {
        logInfo("Delete comment")
        model.update(comment: nil, at: index)
        castView.updateData(withComments: model.state.comments)
    }
    
    // for testing purposes
    enum PaymentResult { case Success, Failure }
    let paymentResult: PaymentResult = .Failure
    
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView) {
        logInfo("Did tap buy")
        
        // TODO: implement payment request
        
        switch paymentResult {
        case .Success:
            sendNavigationEvent(SimpleNavigationEvent(type: .ShowPaymentSuccess))
        case .Failure:
            sendNavigationEvent(SimpleNavigationEvent(type: .ShowPaymentFailure))
        }
        
    }
}

extension CheckoutSummaryViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        animator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension CheckoutSummaryViewController: CheckoutSummaryCommentViewControllerDelegate {
    func checkoutSummaryCommentWantsDismiss(viewController: CheckoutSummaryCommentViewController) {
        commentAnimator.dismissViewController(presentingViewController: self, completion: nil)
    }
    
    func checkoutSummaryCommentWantsSaveAndDimsiss(viewController: CheckoutSummaryCommentViewController) {
        commentAnimator.dismissViewController(presentingViewController: self, completion: nil)
        model.update(comment: viewController.comment, at: viewController.index)
        castView.updateData(withComments: model.state.comments)
    }
}