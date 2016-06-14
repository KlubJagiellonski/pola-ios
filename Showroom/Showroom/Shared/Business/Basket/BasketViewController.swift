import Foundation
import UIKit
import RxSwift

class BasketViewController: UIViewController, BasketViewDelegate {
    private let disposeBag = DisposeBag()
    private let manager: BasketManager
    private var castView: BasketView { return view as! BasketView }
    
    // For testing purposes only
    private let sampleBasketButton: UIButton = UIButton()
    
    init(resolver: DiResolver) {
        self.manager = resolver.resolve(BasketManager.self)
        super.init(nibName: nil, bundle: nil)
        
        self.manager.basketObservable.subscribeNext(updateView).addDisposableTo(disposeBag)
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
        
        // TODO: Remove when API is ready
        initSampleBasketButton()
    }
    
    private func updateView(with newBasket: Basket) {
        castView.updateData(with: newBasket)
        updateSampleButtonVisibility()
    }
    
    // MARK: - BasketViewDelegate
    func basketViewDidDeleteProduct(product: BasketProduct) {
        manager.removeFromBasket(product)
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
        manager.createSampleBasket()
        updateSampleButtonVisibility()
    }
    
    private func updateSampleButtonVisibility() {
        sampleBasketButton.hidden = !manager.currentBasket.isEmpty
    }
}