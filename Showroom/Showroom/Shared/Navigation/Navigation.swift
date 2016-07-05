import Foundation
import UIKit

typealias EventHandled = Bool

protocol NavigationEvent {
    
}

protocol NavigationHandler {
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled
}

protocol NavigationSender {
    func sendNavigationEvent(event: NavigationEvent) -> EventHandled
}

extension NavigationSender where Self: UIViewController {
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

extension UIViewController: NavigationSender {}