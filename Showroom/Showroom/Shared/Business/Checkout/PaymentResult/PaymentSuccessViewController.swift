import UIKit

class PaymentSuccessViewController: UIViewController, PaymentSuccessViewDelegate {
    private let resolver: DiResolver
    private let rateAppManager: RateAppManager
    private var castView: PaymentSuccessView { return view as! PaymentSuccessView }
    private let orderNumber: Int
    private let orderUrl: String
    private lazy var formSheetAnimator: FormSheetAnimator = { [unowned self] in
        let animator = FormSheetAnimator()
        animator.delegate = self
        return animator
    }()
    
    init(resolver: DiResolver, orderNumber: Int, orderUrl: String) {
        self.resolver = resolver
        self.rateAppManager = resolver.resolve(RateAppManager.self)
        self.orderNumber = orderNumber
        self.orderUrl = orderUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PaymentSuccessView(orderNumber: orderNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
        showRateAppViewIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutSuccess)
    }
    
    func paymentSuccessViewDidTapLink(view: PaymentSuccessView) {
        logInfo("paymentSuccessViewDidTapLink")
        
        guard let orderUrl = NSURL(string: orderUrl) else {
            logError("Cannot create url from \(self.orderUrl)")
            return
        }
        
        UIApplication.sharedApplication().openURL(orderUrl)
    }
    
    func paymentSuccessViewDidTapGoToMain(view: PaymentSuccessView) {
        logInfo("paymentSuccessViewDidTapGoToMain")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    
    private func showRateAppViewIfNeeded() {
        guard rateAppManager.shouldShowRateAppView else {
            return
        }
        
        let viewController = resolver.resolve(RateAppViewController.self, argument: RateAppViewType.AfterBuy)
        viewController.preferredContentSize = Dimensions.rateAppPreferredSize
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        rateAppManager.didShowRateAppView()
    }
}

extension PaymentSuccessViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension PaymentSuccessViewController: RateAppViewControllerDelegate {
    func rateAppWantsDismiss(viewController: RateAppViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}