import UIKit

protocol ProductColorViewControllerDelegate: class {
    func productColor(viewController viewController: ProductColorViewController, didChangeColor colorId: ObjectId)
    func productColor(viewController viewController: ProductColorViewController, wantsDismissWithAnimation animation: Bool)
}

class ProductColorViewController: UIViewController, ProductColorViewDelegate {
    private let colors: [ProductColor]
    private let initialSelectedColorId: ObjectId?
    private var firstLayoutSubviewsPassed = false
    
    var castView: ProductColorView { return view as! ProductColorView }
    
    weak var delegate: ProductColorViewControllerDelegate?
    
    init(resolver: DiResolver, colors: [ProductColor], initialSelectedColorId: ObjectId?) {
        self.colors = colors
        self.initialSelectedColorId = initialSelectedColorId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductColorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(colors)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.selectedIndex = colors.indexOf { $0.id == initialSelectedColorId }
        }
    }
    
    // MARK :- ProductColorViewDelegate
    
    func productColor(view view: ProductColorView, didSelectColor colorId: ObjectId) {
        logInfo("Did select color \(colorId)")
        delegate?.productColor(viewController: self, didChangeColor: colorId)
    }
}

extension ProductColorViewController: ExtendedModalViewController {
    func forceCloseWithoutAnimation() {
        logInfo("Forcing close without animation")
        delegate?.productColor(viewController: self, wantsDismissWithAnimation: false)
    }
}