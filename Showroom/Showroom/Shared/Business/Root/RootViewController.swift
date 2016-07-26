import Foundation
import UIKit
import Swinject

class RootViewController: PresenterViewController, NavigationHandler {
    private let model: RootModel
    private let resolver: DiResolver
    private var urlToHandle: NSURL?
    
    init?(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(RootModel.self)
        super.init(nibName: nil, bundle: nil)
        
        showModal(resolver.resolve(SplashViewController.self), hideContentView: false, animation: nil, completion: nil)
        
        switch model.startChildType {
        case .Start:
            showContent(resolver.resolve(StartViewController), animation: nil, completion: nil)
        case .Main:
            showContent(resolver.resolve(MainTabViewController), animation: nil, completion: nil)
        case .Onboarding:
            showContent(resolver.resolve(OnboardingViewController), animation: nil, completion: nil)
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
            model.shouldSkipStartScreen = true
            let mainTabViewController = resolver.resolve(MainTabViewController)
            showContent(mainTabViewController, animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            if let urlToHandle = urlToHandle {
                mainTabViewController.handleOpen(withURL: urlToHandle)
                self.urlToHandle = nil
            }
            return true
        case .SplashEnd:
            hideModal(animation: nil, completion: nil)
            return true
        case .OnboardingEnd:
            showContent(resolver.resolve(StartViewController), animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            return true
        default: return false
        }
    }
}

extension RootViewController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        if let mainTabViewController = self.contentViewController as? MainTabViewController {
            return mainTabViewController.handleOpen(withURL: url)
        } else if model.shouldSkipStartScreen {
            let mainTabViewController = resolver.resolve(MainTabViewController.self)
            showContent(mainTabViewController, animation: nil, completion: nil)
            return mainTabViewController.handleOpen(withURL: url)
        } else {
            //wait with handling till app finish onboarding and start
            urlToHandle = url
            return true
        }
    }
}