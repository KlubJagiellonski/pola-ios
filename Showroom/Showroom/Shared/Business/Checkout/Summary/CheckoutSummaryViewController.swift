import UIKit
import RxSwift
import RxCocoa

final class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
    private let disposeBag = DisposeBag()
    private let model: CheckoutModel
    private var castView: CheckoutSummaryView { return view as! CheckoutSummaryView }
    private let resolver: DiResolver
    private let commentAnimator = FormSheetAnimator()
    private let toastManager: ToastManager
    
    init(resolver: DiResolver, model: CheckoutModel) {
        self.resolver = resolver
        self.toastManager = resolver.resolve(ToastManager.self)
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        model.initializePaymentHandler()
        model.paymentDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        model.invalidatePaymentHandler()
    }
    
    override func loadView() {
        view = CheckoutSummaryView(with: model.state.checkout, comments: model.state.comments) { [unowned self] payUButtonFrame in
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

        model.state.buyButtonEnabled.asObservable().subscribeNext { [weak self] enabled in
            self?.castView.update(buyButtonEnabled: enabled)
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutSummary)
    }
    
    private func showCommentModal(forComment comment: String?, at index: Int) {
        logInfo("Show comment modal for comment: \(comment), at index: \(index)")
        let viewController = resolver.resolve(CheckoutSummaryCommentViewController.self, arguments: (comment, index))
        viewController.delegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 264)
        commentAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    private func handlePaymentError(error: ErrorType) {
        var moveToBasket = false
        var errorToast: String?
        var paymentResult: PaymentResult?
        var clearBasket = false
        
        let handlePayUError: PaymentResult -> Void = { result in
            //it means that something went wrong with PayU payment. Show error view and clear basket. Possible that payment went ok
            logInfo("PayU error: something went wrong with payU payment. Show error view and clear basket. It is possible that payment went ok.")
            paymentResult = result
            clearBasket = true
        }
        
        if let paymentError = error as? PaymentHandlerError {
            switch paymentError {
            case .NoPaymentHandler: break
            case .CannotCreatePayment:
                //means that something is wrong with input data. Cancel payment and show basket.
                logError("Payment error: cannot create payment. There is something wrong with input data. Cancel payment and show basket.")
                errorToast = tr(.CommonError)
                moveToBasket = true
            case .PaymentRequestFailed(let requestFailedError):
                if let urlError = requestFailedError as? RxCocoaURLError, case let .HTTPRequestFailed(response, _) = urlError {
                    switch response.statusCode {
                    case 400..<500:
                        //means that something is wrong with with params. Need to go back to bask and validate it again
                        logError("Payment error: payment request failed with status code \(response.statusCode): something is wrong with params. Need to go back to basket and validate it again.")
                        errorToast = tr(.CheckoutPaymentOn400Error)
                        moveToBasket = true
                    default:
                        //other means 5xx which is server error. Try again if possible
                        logInfo("Payment error: payment request failed with status code \(response.statusCode): server error. Try again if possible.")
                        errorToast = tr(.CommonError)
                    }
                } else if let apiError = requestFailedError as? ApiError {
                    logInfo("API error: \(apiError)")
                    errorToast = tr(.CommonUserLoggedOut)
                    moveToBasket = true
                } else {
                    //other http error or NSURLDomainError - treat as 5xx
                    logInfo("Payment error: payment request failed: unknown http error or NSURLDomainError")
                    errorToast = tr(.CommonError)
                }
            case .PayUInvalidRequest(let result): handlePayUError(result)
            case .PayUUserWantsRetry(let result): handlePayUError(result)
            case .PayUCancelled(let result): handlePayUError(result)
            case .BrainTreeFetchingTokenError(let fetchingTokenError):
                logInfo("Cannot fetch braintree token \(fetchingTokenError)")
                errorToast = tr(.CommonError)
            case .BrainTreeError(let unknownError):
                logInfo("Cannot retrieve nonce with error \(unknownError)")
                errorToast = tr(.CommonError)
            case .BrainTreeCreatingClientError:
                logInfo("Cannot create client error")
                errorToast = tr(.CommonError)
            case .BrainTreeCancelled:
                logInfo("User cancelled braintree payment")
            }
        } else {
            //shouldn't happen
            fatalError("Received wrong error: \(error)")
        }
        
        if let errorToast = errorToast {
            toastManager.showMessage(errorToast)
        }
        
        if clearBasket {
            self.model.clearBasket()
        }
        
        if moveToBasket {
            sendNavigationEvent(SimpleNavigationEvent(type: .Close))
        } else if let paymentResult = paymentResult {
            sendNavigationEvent(ShowPaymentFailureEvent(orderId: paymentResult.orderId, orderUrl: paymentResult.orderUrl))
        }
    }
    
    // MARK: - CheckoutSummaryViewDelegate
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int) {
        logInfo("Checkout summary view did tap add comment at index: \(index)")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryAddNoteClicked)
        showCommentModal(forComment: nil, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int) {
        logInfo("Checkout summary view did tap edit comment at index: \(index)")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryEditNoteClicked)
        let editedComment = model.comment(at: index)
        showCommentModal(forComment: editedComment, at: index)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int) {
        logInfo("Checkout summary view did tap delete comment at index: \(index)")
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryDeleteNoteClicked)
        model.update(comment: nil, at: index)
        castView.updateData(withComments: model.state.comments)
    }
    
    func checkoutSummaryView(view: CheckoutSummaryView, didSelectPaymentWithType type: PaymentType) {
        logInfo("Checkout summary view did select payment at index: \(index)")
        model.updateSelectedPayment(forType: type)
        logAnalyticsEvent(AnalyticsEventId.CheckoutSummaryPaymentMethodClicked(model.state.selectedPayment.id.rawValue))
    }
    
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView) {
        logInfo("Checkout summary view did tap buy")
        
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
                self.sendNavigationEvent(ShowPaymentSuccessEvent(orderId: result.orderId, orderUrl: result.orderUrl))
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
        logInfo("Animator did tap on dim view")
        animator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension CheckoutSummaryViewController: CheckoutSummaryCommentViewControllerDelegate {
    func checkoutSummaryCommentWantsDismiss(viewController: CheckoutSummaryCommentViewController, animated: Bool) {
        commentAnimator.dismissViewController(presentingViewController: self, animated: animated)
    }
    
    func checkoutSummaryCommentWantsSaveAndDimsiss(viewController: CheckoutSummaryCommentViewController) {
        commentAnimator.dismissViewController(presentingViewController: self, completion: nil)
        model.update(comment: viewController.comment, at: viewController.index)
        castView.updateData(withComments: model.state.comments)
    }
}

extension CheckoutSummaryViewController: PaymentHandlerDelegate {
    func paymentHandlerDidChange() {
        logInfo("Payment service did change")
        model.updateBuyButtonState()
    }
    
    func paymentHandlerWantsPresentViewController(viewController: UIViewController) {
        logInfo("Payment service did request presenting view controller: \(viewController)")
        presentViewController(viewController, animated: true, completion: nil)
    }
}
