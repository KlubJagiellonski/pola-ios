import Foundation
import UIKit

class BasketViewController: UIViewController {
    let model: BasketModel
    var castView: BasketView { return view as! BasketView }
    
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasketViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
       model.createSampleBasket()
        
//        do {
//            try model.load()
//        } catch {
//            logInfo("Error during loading basket from file")
//        }
        
        castView.updateData(withBasket: model.basket)
//        do {
//            try model.saveCurrentBasket()
//        } catch {
//            logInfo("Error during saving basket to file")
//        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}