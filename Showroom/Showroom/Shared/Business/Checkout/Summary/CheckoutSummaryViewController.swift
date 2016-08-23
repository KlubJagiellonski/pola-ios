import UIKit
import RxSwift
import RxCocoa

final class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
    private let disposeBag = DisposeBag()
    private let manager: BasketManager
    private let model: CheckoutModel
    private var castView: CheckoutSummaryView { return view as! CheckoutSummaryView }
    private let resolver: DiResolver
    private let commentAnimator = FormSheetAnimator()
    private let toastManager: ToastManager
    
    init(resolver: DiResolver, model: CheckoutModel) {
        self.resolver = resolver
        self.manager = resolver.resolve(BasketManager.self)
        self.toastManager = resolver.resolve(ToastManager.self)
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        model.payUDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryView() { [unowned self] payUButtonFrame in
            guard let button = self.model.payUButton(withFrame: payUButtonFrame) else {
                self.sendNavigationEvent(SimpleNavigationEvent(type: .Close))
                return UIView()
            }
            return button
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
    
    private func handlePaymentError(error: ErrorType) {
        var showErrorAndMoveToBasket = false
        var showErrotToast = false
        var showErrorView = false
        var clearBasket = false
        
        if let paymentError = error as? PaymentError {
            switch paymentError {
            case .CannotCreatePayment:
                //means that something is wrong with input data. Cancel payment and show basket.
                showErrorAndMoveToBasket = true
            case .PaymentRequestFailed(let requestFailedError):
                if let urlError = requestFailedError as? RxCocoaURLError, case let .HTTPRequestFailed(response, _) = urlError {
                    switch response.statusCode {
                    case 400..<500:
                        //means that something is wrong with with params. Need to go back to bask and validate it again
                        showErrorAndMoveToBasket = true
                    default:
                        //other means 5xx which is server error. Try again if possible
                        showErrotToast = true
                    }
                } else {
                    //other http error or NSURLDomainError - treat as 5xx
                    showErrotToast = true
                }
            }
        } else if error is PayUPaymentError {
            //it means that something went wrong with PayU payment. Show error view and clear basket. Possible that payment went ok
            showErrorView = true
            clearBasket = true
        } else {
            //shouldn't happen
            fatalError("Received wrong error: \(error)")
        }
        
        if showErrorAndMoveToBasket {
            toastManager.showMessage(tr(.CheckoutPaymentOn400Error))
            sendNavigationEvent(SimpleNavigationEvent(type: .Close))
        }
        if showErrotToast {
            toastManager.showMessage(tr(.CommonError))
        }
        if showErrorView {
            self.sendNavigationEvent(SimpleNavigationEvent(type: .ShowPaymentFailure))
        }
        if clearBasket {
            self.model.clearBasket()
        }
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
    
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView) {
        logInfo("Did tap buy")
        
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryFinishButtonClicked)
        
        castView.changeSwitcherState(.ModalLoading)
        navigationItem.hidesBackButton = true
        
        model.makePayment().subscribe { [weak self] (event: Event<PaymentResult>) in
            guard let `self` = self else { return }
            
            self.castView.changeSwitcherState(.Success)
            self.navigationItem.hidesBackButton = false
            
            switch event {
            case .Next(let result):
                logInfo("Payment success \(result)")
                logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryPaymentStatus(true, self.model.state.selectedPayment.id.rawValue))
                logAnalyticsTransactionEvent(with: result, products: self.model.state.checkout.basket.products)
                self.sendNavigationEvent(SimpleNavigationEvent(type: .ShowPaymentSuccess))
                self.model.clearBasket()
            case .Error(let error):
                logInfo("Payment error \(error)")
                logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryPaymentStatus(false, self.model.state.selectedPayment.id.rawValue))
                self.handlePaymentError(error)
            default: break
            }
        }.addDisposableTo(disposeBag)
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