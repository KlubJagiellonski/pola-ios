import UIKit

protocol EditAddressViewControllerDelegate: class {
    func editAddressViewController(viewController: EditAddressViewController, didAddNewUserAddress userAddress: UserAddress)
    func editAddressViewController(viewController: EditAddressViewController, didEditUserAddress userAddress: UserAddress)
}

class EditAddressViewController: UIViewController, EditAddressViewDelegate {
    var castView: EditAddressView { return view as! EditAddressView }
    
    private let userAddress: UserAddress?
    private let defaultCountry: String
    
    weak var delegate: EditAddressViewControllerDelegate?
    
    init(with userAddress: UserAddress?, defaultCountry: String) {
        self.userAddress = userAddress
        self.defaultCountry = defaultCountry
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = EditAddressView(userAddress: userAddress, defaultCountry: defaultCountry)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutDeliveryEditAddress)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editAddressViewDidTapSaveButton(view: EditAddressView) {
        guard castView.validate(showResult: true) else { return }
        guard let newUserAddress = castView.userAddress else { return }
        
        if userAddress != nil {
            delegate?.editAddressViewController(self, didEditUserAddress: newUserAddress)
        } else {
            delegate?.editAddressViewController(self, didAddNewUserAddress: newUserAddress)
        }
    }
}