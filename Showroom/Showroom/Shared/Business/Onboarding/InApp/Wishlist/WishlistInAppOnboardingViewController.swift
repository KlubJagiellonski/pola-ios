import UIKit

protocol WishlistInAppOnboardingViewControllerDelegate: class {
    func wishlistOnboardingViewControllerDidTapDismissButton(viewController: WishlistInAppOnboardingViewController)
}

class WishlistInAppOnboardingViewController: UIViewController, WishlistInAppOnboardingViewDelegate {
    
    private var castView: WishlistInAppOnboardingView { return view as! WishlistInAppOnboardingView }
    
    weak var delegate: WishlistInAppOnboardingViewControllerDelegate?
    
    override func loadView() {
        view = WishlistInAppOnboardingView()
    }
    
    override func viewDidLoad() {
        castView.delegate = self
    }
    
    func wishlistOnboardingViewDidTapDismissButton(view: WishlistInAppOnboardingView) {
        logInfo("Wishlist onboarding view did tap dismiss button")
        delegate?.wishlistOnboardingViewControllerDidTapDismissButton(self)
    }
    
}