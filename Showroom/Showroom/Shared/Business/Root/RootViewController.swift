import Foundation
import UIKit
import Swinject

class RootViewController: PresenterViewController, NavigationHandler {
    let model: RootModel
    let resolver: DiResolver
    
    init?(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(RootModel.self)
        
        super.init(nibName: nil, bundle: nil)
        
        switch model.startChildType {
        case .Start:
            self.contentViewController = resolver.resolve(StartViewController)
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
    
    // MARK: - NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        guard let simpleEvent = event as? SimpleNavigationEvent else { return false }
        
        switch simpleEvent.type {
        case .ShowDashboard:
            self.contentViewController = resolver.resolve(MainTabViewController)
            return true
        default: return false
        }
    }
}