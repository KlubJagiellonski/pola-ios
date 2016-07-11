import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private var castView: SplashView { return view as! SplashView }
    
    override func loadView() {
        view = SplashView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.startAnimation {[weak self] _ in
            self?.sendNavigationEvent(SimpleNavigationEvent(type: .SplashEnd))
        }
    }
}
