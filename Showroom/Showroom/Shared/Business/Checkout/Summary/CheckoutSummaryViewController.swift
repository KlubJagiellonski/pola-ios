import UIKit

class CheckoutSummaryViewController: UIViewController, CheckoutSummaryViewDelegate {
    private let manager: BasketManager
    private var castView: CheckoutSummaryView { return view as! CheckoutSummaryView }
    private let resolver: DiResolver
    private let commentAnimator = FormSheetAnimator()
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CheckoutSummaryView()
        castView.delegate = self;
        commentAnimator.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.updateData(with: manager.state.basket)
    }
    
    private func showCommentModal()
    {
        let viewController = resolver.resolve(CheckoutSummaryCommentViewController.self)
        viewController.delegate = self
        viewController.modalPresentationStyle = .FormSheet
        viewController.preferredContentSize = CGSize(width: 292, height: 264)
        commentAnimator.presentViewController(viewController, presentingViewController: self, completion: nil)
    }
    
    // MARK: - CheckoutSummaryViewDelegate
    
    func checkoutSummaryViewDidTapAddComment(brand: BasketBrand) {
        logInfo("Add comment to " + brand.name)
        showCommentModal()
    }
    
    func checkoutSummaryViewDidTapEditComment(brand: BasketBrand) {
        logInfo("Edit comment to " + brand.name)
        showCommentModal()
    }
    
    func checkoutSummaryViewDidTapDeleteComment(brand: BasketBrand) {
        logInfo("Delete comment to " + brand.name)
    }
}

extension CheckoutSummaryViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        animator.dismissViewController(presentingViewController: self, completion: nil)
    }
}

extension CheckoutSummaryViewController: CheckoutSummaryCommentViewControllerDelegate {
    func checkoutSummaryCommentWantsDismiss(viewController: CheckoutSummaryCommentViewController) {
        commentAnimator.dismissViewController(presentingViewController: self, completion: nil)
    }
    
    func checkoutSummaryCommentWantsSaveAndDimsiss(viewController: CheckoutSummaryCommentViewController) {
        commentAnimator.dismissViewController(presentingViewController: self, completion: nil)
        // TODO: Save the new comment in CheckoutNavigationController
    }
}