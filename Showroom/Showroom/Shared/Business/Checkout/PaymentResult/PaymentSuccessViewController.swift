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
        logInfo("Payment success view did tap link")
        
        guard let orderUrl = NSURL(string: orderUrl) else {
            logError("Cannot create url from \(self.orderUrl)")
            return
        }
        
        UIApplication.sharedApplication().openURL(orderUrl)
    }
    
    func paymentSuccessViewDidTapGoToMain(view: PaymentSuccessView) {
        logInfo("Payment success view did tap go to main")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    
    private func showRateAppViewIfNeeded() {
        guard rateAppManager.shouldShowRateAppView else {
            logInfo("Showing rate app view was not needed")
            return
        }
        logInfo("Show rate app view")
        
        let viewController = resolver.resolve(RateAppViewController.self, argument: RateAppViewType.AfterBuy)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        rateAppManager.didShowRateAppView()
    }
}

extension PaymentSuccessViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        logInfo("Animator did tap on dim view")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension PaymentSuccessViewController: RateAppViewControllerDelegate {
    func rateAppWantsDismiss(viewController: RateAppViewController) {
        logInfo("Rate app view controller wants dismiss")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}