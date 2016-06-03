import Foundation
import UIKit

class ProductPageViewController: UIViewController {
    let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
}