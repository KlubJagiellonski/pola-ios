import UIKit

class HistoryOfOrderViewController: UIViewController, HistoryOfOrderViewDelegate {

    private var castView: HistoryOfOrderView { return view as! HistoryOfOrderView }
    private let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = HistoryOfOrderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    func historyOfOrderViewdidTapGoToWebsite(view: HistoryOfOrderView) {
        logInfo("historyOfOrderViewdidTapGoToWebsite")
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.showroom.pl/c/orders")!)
    }
}