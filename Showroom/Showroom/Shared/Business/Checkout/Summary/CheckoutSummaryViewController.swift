import UIKit
import RxSwift

final class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
    private let disposeBag = DisposeBag()
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
        
        model.payUDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryView() { [unowned self] payUButtonFrame in
            return self.model.payUButton(withFrame: payUButtonFrame)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        commentAnimator.delegate = self
        
        let discountCode = manager.state.basket?.discountErrors == nil ? manager.state.discountCode : nil
        castView.updateData(with: manager.state.basket, carrier: manager.state.deliveryCarrier, discountCode: discountCode, comments: model.state.comments)
        
        model.state.buyButtonEnabled.asObservable().subscribeNext { [weak self] enabled in
            self?.castView.update(buyButtonEnabled: enabled)
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutSummary)
    }
    
    private func showCommentModal(forComment comment: String?, at index: Int) {
        let viewController = resolver.resolve(CheckoutSummaryCommentViewController.self, arguments: (comment, index))
        viewController.delegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 264)
        commentAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    // MARK: - CheckoutSummaryViewDelegate
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int) {
        logInfo("Add comment")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryAddNoteClicked)
        showCommentModal(forComment: nil, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int) {
        logInfo("Edit comment")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryEditNoteClicked)
        let editedComment = model.comment(at: index)
        showCommentModal(forComment: editedComment, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int) {
        logInfo("Delete comment")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryDeleteNoteClicked)
        model.update(comment: nil, at: index)
        castView.updateData(withComments: model.state.comments)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didSelectPaymentAt index: Int) {
        model.updateSelectedPayment(forIndex: index)
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryPaymentMethodClicked(model.state.selectedPayment.id.rawValue))
    }
    
    // for testing purposes
    enum PaymentResult { case Success, Failure }
    let paymentResult: PaymentResult = .Failure
    
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView) {
        logInfo("Did tap buy")
        
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryFinishButtonClicked)
        
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

extension CheckoutSummaryViewController: PUPaymentServiceDelegate {
    func paymentServiceDidRequestPresentingViewController(viewController: UIViewController!) {
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func paymentServiceDidSelectPaymentMethod(paymentMethod: PUPaymentMethodDescription!) {
        model.updateBuyButtonState()
    }
}