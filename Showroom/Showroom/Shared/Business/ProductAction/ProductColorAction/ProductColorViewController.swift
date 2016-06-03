import UIKit

protocol ProductColorViewControllerDelegate: class {
    func productColor(viewController viewController: ProductColorViewController, didChangeColor color: ProductColor)
}

class ProductColorViewController: UIViewController, ProductColorViewDelegate {
    let colors: [ProductColor] = [
        ProductColor(id: 0, name: "Czarny", color: .Color(UIColor.blackColor()), isAvailable: true),
        ProductColor(id: 1, name: "Czerwony", color: .Color(UIColor.redColor()), isAvailable: false),
        ProductColor(id: 2, name: "Jasnoniebieski", color: .ImageUrl("http://placehold.it/100/aaffff"), isAvailable: false),
        ProductColor(id: 3, name: "Niebieski", color: .Color(UIColor.blueColor()), isAvailable: true),
        ProductColor(id: 4, name: "Fioletowy", color: .Color(UIColor.purpleColor()), isAvailable: false),
        ProductColor(id: 5, name: "Różowy", color: .ImageUrl("http://placehold.it/100/ffaaff"), isAvailable: true),
    ]   //temporary data source
    
    var castView: ProductColorView { return view as! ProductColorView }
    
    weak var delegate: ProductColorViewControllerDelegate?
    
    override func loadView() {
        view = ProductColorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(colors)
    }
    
    init(resolver: DiResolver) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK :- ProductColorViewDelegate
    
    func productColor(view view: ProductColorView, didSelectColor color: ProductColor) {
        delegate?.productColor(viewController: self, didChangeColor: color)
    }
}
