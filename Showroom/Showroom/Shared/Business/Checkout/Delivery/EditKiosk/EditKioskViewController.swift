import UIKit
import CoreLocation
import RxSwift

protocol EditKioskViewControllerDelegate: class {
    func editKioskViewControllerDidChooseKiosk(viewController: EditKioskViewController, kiosk: Kiosk)
}

class EditKioskViewController: UIViewController, EditKioskViewDelegate {
    private let model: EditKioskModel
    private let disposeBag = DisposeBag()
    
    private var castView: EditKioskView { return view as! EditKioskView }
    
    weak var delegate: EditKioskViewControllerDelegate?
    
    init(with resolver: DiResolver, and checkoutModel: CheckoutModel) {
        self.model = resolver.resolve(EditKioskModel.self, argument: checkoutModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = EditKioskView(kioskSearchString: model.checkoutModel.state.selectedAddress?.displayAddress )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
        
        if let searchString = castView.searchString {
            fetchKiosks(withAddressString: searchString)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    func fetchKiosks(withAddressString addressString: String) {
        castView.switcherState = .Loading
        castView.selectedIndex = nil
        
        model.fetchKiosks(withAddressString: addressString)
            .subscribe {[weak self] (kiosksResult: Event<KioskResult>) in
                guard let `self` = self else { return }
                switch kiosksResult {
                case .Error(let error):
                    logInfo("fetched kiosks error: \(error)")
                    if let error = error as? CLError {
                        switch error {
                        case .GeocodeFoundNoResult:
                            self.castView.switcherState = .Empty
                            self.castView.geocodingErrorVisible = true
                        case .Network:
                            self.castView.switcherState = .Error
                            self.castView.geocodingErrorVisible = false
                        case .GeocodeCanceled:
                            break
                        default:
                            self.castView.switcherState = .Success
                            self.castView.geocodingErrorVisible = true
                        }
                    } else {
                        self.castView.switcherState = .Error
                    }
                case .Next(let result):
                    logInfo("fetched kiosks: \(result.kiosks)")
                    self.castView.updateKiosks(result.kiosks)
                    self.castView.switcherState = .Success
                    self.castView.geocodingErrorVisible = false
                default: break
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: EditKioskViewDelegate
    
    func editKioskView(view: EditKioskView, didReturnSearchString searchString: String) {
        fetchKiosks(withAddressString: searchString)
    }
    
    func editKioskView(view: EditKioskView, didChooseKioskAtIndex kioskIndex: Int) {
        guard let kiosks = model.kiosks else { return }
        delegate?.editKioskViewControllerDidChooseKiosk(self, kiosk: kiosks[kioskIndex])
    }
    
    // MARK: ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        guard let searchString = castView.searchString else { return }
        fetchKiosks(withAddressString: searchString)
    }
}

extension UserAddress {
    private var displayAddress: String {
        return "\(streetAndAppartmentNumbers), \(city)"
    }
}


