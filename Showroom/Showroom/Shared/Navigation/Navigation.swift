import Foundation
import UIKit

typealias EventHandled = Bool

protocol NavigationEvent {
    
}

protocol NavigationHandler {
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled
}

extension UIViewController {
    func sendNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let navigatationHandler = self as? NavigationHandler {
            guard !navigatationHandler.handleNavigationEvent(event) else { return true }
        }
        
        if let parent = parentViewController {
            return parent.sendNavigationEvent(event)
        }
        
        logError("Cannot handle navigation event \(event)")
        return false
    }
}