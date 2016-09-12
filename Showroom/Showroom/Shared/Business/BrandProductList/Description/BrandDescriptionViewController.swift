import Foundation
import UIKit

class BrandDescriptionViewController: UIViewController {
    private let brand: Brand
    
    private var castView: BrandDescriptionView { return view as! BrandDescriptionView }
    
    init(with brand: Brand) {
        self.brand = brand
        super.init(nibName: nil, bundle: nil)
        
        title = tr(.BrandAboutTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BrandDescriptionView(with: brand)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.BrandDescription)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
}
