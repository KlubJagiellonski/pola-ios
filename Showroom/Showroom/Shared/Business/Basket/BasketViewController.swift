import Foundation
import UIKit

class BasketViewController: UIViewController, BasketViewDelegate {
    let model: BasketModel
    var castView: BasketView { return view as! BasketView }
    let sampleBasketButton: UIButton = UIButton()
    
    init(resolver: DiResolver) {
        self.model = resolver.resolve(BasketModel.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BasketView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.updateData(withBasket: model.basket)
        
        // TODO: Remove when API is ready
        initSampleBasketButton()
    }
    
    // MARK: - BasketViewDelegate
    func basketViewDidDeleteProduct(product: BasketProduct) {
        model.removeFromBasket(product)
        castView.updateData(withBasket: model.basket)
        updateSampleButtonVisibility()
    }
    
    // MARK: - Sample basket for testing
    private func initSampleBasketButton() {
        sampleBasketButton.setTitle("ADD SAMPLE PRODUCTS", forState: .Normal)
        sampleBasketButton.applyPlainStyle()
        sampleBasketButton.addTarget(self, action: #selector(BasketViewController.sampleButtonPressed(_:)), forControlEvents: .TouchUpInside)
        castView.addSubview(sampleBasketButton)
        
        sampleBasketButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func sampleButtonPressed(sender: UIButton) {
        model.createSampleBasket()
        castView.updateData(withBasket: model.basket)
        updateSampleButtonVisibility()
    }
    
    private func updateSampleButtonVisibility() {
        sampleBasketButton.hidden = !model.basket.isEmpty
    }
}