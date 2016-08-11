import UIKit

protocol ProductPagingInAppOnboardingViewControllerDelegate: class {
    func productPagingOnboardingViewControllerDidTapDismissButton(viewController: ProductPagingInAppOnboardingViewController)
}

class ProductPagingInAppOnboardingViewController: UIViewController, ProductPagingInAppOnboardingViewDelegate {
    
    private var castView: ProductPagingInAppOnboardingView { return view as! ProductPagingInAppOnboardingView }
    
    weak var delegate: ProductPagingInAppOnboardingViewControllerDelegate?
    
    override func loadView() {
        view = ProductPagingInAppOnboardingView()
    }
    
    override func viewDidLoad() {
        castView.delegate = self
    }
    
    func productPagingOnboardingViewDidTapDismissButton(view: ProductPagingInAppOnboardingView) {
        delegate?.productPagingOnboardingViewControllerDidTapDismissButton(self)
    }
    
}