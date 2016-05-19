import Foundation
import UIKit
import Swinject

class RootViewController: UIViewController {
    let model: RootModel
    var castView: RootView { return view as! RootView }
    
    var contentViewController: UIViewController
    
    init?(resolver: DiResolver) {
        self.model = resolver.resolve(RootModel.self)
        
        switch model.startChildType {
        case .Main:
            contentViewController = resolver.resolve(MainTabViewController)
        default:
            let error = "Cannot create view controller for type \(model.startChildType)"
            logError(error)
            return nil
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = RootView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(contentViewController)
        castView.contentView = contentViewController.view
        contentViewController.didMoveToParentViewController(self)
    }
}