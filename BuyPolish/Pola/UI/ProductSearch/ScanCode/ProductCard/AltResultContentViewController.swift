import UIKit

final class AltResultContentViewController: UIViewController {
    let result: ScanResult
    
    init(result: ScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AltResultContentView()
    }
    
    override func viewDidLoad() {
        let altView = view as! AltResultContentView
        altView.textLabel.text = result.altText
    }
}
