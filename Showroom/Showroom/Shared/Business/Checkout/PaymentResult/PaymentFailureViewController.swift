import UIKit

class PaymentFailureViewController: UIViewController, PaymentFailureViewDelegate {
    
    private var castView: PaymentFailureView { return view as! PaymentFailureView }
    
    private let orderNumber: Int
    
    init(resolver: DiResolver, orderNumber: Int) {
        self.orderNumber = orderNumber
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
    
    func paymentFailureViewDidTapLink(view: PaymentFailureView) {
        logInfo("paymentFailureViewDidTapLink")

        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.showroom.pl/c/orders")!)
        
        // TODO: go to wkwebview (?) with user authentication
    }
    
    func paymentFailureViewDidTapGoToMain(view: PaymentFailureView) {
        logInfo("paymentFailureViewDidTapGoToMain")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
}