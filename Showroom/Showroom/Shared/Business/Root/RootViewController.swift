import Foundation
import UIKit
import Swinject

class RootViewController: PresenterViewController {
    let model: RootModel
    
    init?(resolver: DiResolver) {
        self.model = resolver.resolve(RootModel.self)
        
        super.init(nibName: nil, bundle: nil)
        
        switch model.startChildType {
        case .Main:
            self.contentViewController = resolver.resolve(MainTabViewController)
        default:
            let error = "Cannot create view controller for type \(model.startChildType)"
            logError(error)
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}