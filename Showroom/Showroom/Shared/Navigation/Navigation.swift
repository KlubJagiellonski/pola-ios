import Foundation
import UIKit

typealias EventHandled = Bool

protocol NavigationEvent {
    
}

protocol NavigationHandler {
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled
}

extension UIViewController {
    func sendNavigationEvent(event: NavigationEvent) {
        if let navigatationHandler = self as? NavigationHandler {
            guard !navigatationHandler.handleNavigationEvent(event) else { return }
        }
        
        if let parent = parentViewController {
            parent.sendNavigationEvent(event)
            return
        }
        
        logError("Cannot handle navigation event \(event)")
    }
}