import UIKit

class CompanyAltContentViewController: UIViewController {
    let result: BPScanResult
    
    init(result: BPScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CompanyAltContentView()
    }
    
    override func viewDidLoad() {
        let altView = view as! CompanyAltContentView
        altView.textLabel.text = result.altText
    }
}
