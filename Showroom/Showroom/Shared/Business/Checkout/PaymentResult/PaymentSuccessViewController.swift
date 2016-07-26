import UIKit

class PaymentSuccessViewController: UIViewController, PaymentSuccessViewDelegate {
    
    private var castView: PaymentSuccessView { return view as! PaymentSuccessView }
    
    private let orderNumber: Int
    
    init(resolver: DiResolver, orderNumber: Int) {
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
}