import UIKit

protocol PagingInAppOnboardingViewControllerDelegate: class {
    func pagingOnboardingViewControllerDidTapDismiss(viewController: PagingInAppOnboardingViewController)
}

class PagingInAppOnboardingViewController: UIViewController, PagingInAppOnboardingViewDelegate {
    
    private var castView: PagingInAppOnboardingView { return view as! PagingInAppOnboardingView }
    
    weak var delegate: PagingInAppOnboardingViewControllerDelegate?
    
    override func loadView() {
        view = PagingInAppOnboardingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    func pagingOnboardingDidTapDismiss(view: PagingInAppOnboardingView) {
        delegate?.pagingOnboardingViewControllerDidTapDismiss(self)
    }
}