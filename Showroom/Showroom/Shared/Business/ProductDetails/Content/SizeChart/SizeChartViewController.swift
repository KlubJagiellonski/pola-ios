import Foundation
import UIKit

protocol SizeChartViewControllerDelegate {
    func sizeChartDidTapBack(viewController: SizeChartViewController)
}

class SizeChartViewController: UIViewController {
    let sizes: [ProductDetailsSize]
    var castView: SizeChartView { return view as! SizeChartView }
    var delegate: SizeChartViewControllerDelegate?
    var viewContentInset: UIEdgeInsets?
    
    init(sizes: [ProductDetailsSize]) {
        self.sizes = sizes
        super.init(nibName: nil, bundle: nil)
        title = tr(.ProductDetailsSizeChartUppercase)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SizeChartView(sizes: sizes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.contentInset = viewContentInset
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        castView.updateHeaderBackground(true)
        logAnalyticsShowScreen(.ProductSizeChart)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.updateHeaderBackground(false, animationDuration: animated ? 0.3 : 0.0)
    }
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
    
        if !isAppearing {
            castView.headerHidden = false
        }
    }
}
