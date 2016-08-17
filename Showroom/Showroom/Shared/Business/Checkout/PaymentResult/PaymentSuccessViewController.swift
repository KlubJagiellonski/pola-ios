import UIKit

class PaymentSuccessViewController: UIViewController, PaymentSuccessViewDelegate {
    private let resolver: DiResolver
    private let rateAppManager: RateAppManager
    private var castView: PaymentSuccessView { return view as! PaymentSuccessView }
    private let orderNumber: Int
    private lazy var formSheetAnimator: FormSheetAnimator = { [unowned self] in
        let animator = FormSheetAnimator()
        animator.delegate = self
        return animator
    }()
    
    init(resolver: DiResolver, orderNumber: Int) {
        self.resolver = resolver
        self.rateAppManager = resolver.resolve(RateAppManager.self)
        self.orderNumber = orderNumber
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
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.showroom.pl/c/orders")!)
        
        // TODO: go to wkwebview (?) with user authentication
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