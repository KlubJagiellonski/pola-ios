import Foundation
import UIKit
import SnapKit

class WishlistViewController: UIViewController {
    init(resolver: DiResolver) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //todo testcode remove it in future
        let indicator = LoadingIndicator()
        view.addSubview(indicator)
        indicator.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //todo testcode remove it in future
        let indicator = view.subviews[0] as! LoadingIndicator
        indicator.startAnimation()
    }
}
