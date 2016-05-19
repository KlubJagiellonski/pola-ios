import Foundation
import UIKit

class DashboardViewController: UIViewController, DashboardViewDelegate {
    let model: DashboardModel
    var castView: DashboardView { return view as! DashboardView }
    
    init(resolver: DiResolver) {
        self.model = resolver.resolve(DashboardModel.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DashboardView(dataSource: DashboardDataSource())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
}