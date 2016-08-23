import UIKit

class PaymentFailureViewController: UIViewController, PaymentFailureViewDelegate {
    
    private var castView: PaymentFailureView { return view as! PaymentFailureView }
    
    private let orderNumber: Int
    private let orderUrl: String
    
    init(resolver: DiResolver, orderNumber: Int, orderUrl: String) {
        self.orderNumber = orderNumber
        self.orderUrl = orderUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PaymentFailureView(orderNumber: orderNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutError)
    }
    
    func paymentFailureViewDidTapLink(view: PaymentFailureView) {
        logInfo("paymentFailureViewDidTapLink")

        guard let orderUrl = NSURL(string: orderUrl) else {
            logError("Cannot create url from \(self.orderUrl)")
            return
        }
        
        UIApplication.sharedApplication().openURL(orderUrl)
    }
    
    func paymentFailureViewDidTapGoToMain(view: PaymentFailureView) {
        logInfo("paymentFailureViewDidTapGoToMain")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
}