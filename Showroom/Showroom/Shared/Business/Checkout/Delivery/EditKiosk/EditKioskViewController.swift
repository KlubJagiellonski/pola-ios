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
    
    private let clientAddress: [AddressFormField]
    
    private var kiosks: [Kiosk]? {
        get { return model.kiosks }
        set { model.kiosks = newValue }
    }
    
    private(set) var selectedKioskIndex: Int? {
        get { return castView.selectedIndex }
        set { castView.selectedIndex = newValue }
    }
    
    weak var delegate: EditKioskViewControllerDelegate?
    
    init(resolver: DiResolver, clientAddress: [AddressFormField]) {
        self.model = EditKioskModel(api: resolver.resolve(ApiService.self))
        self.clientAddress = clientAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = EditKioskView(kioskSearchString: kioskSearchString(fromClientAddress: clientAddress))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
        fetchKiosks(withAddressString: castView.searchString)
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
        selectedKioskIndex = nil
        
        model.fetchKiosks(withAddressString: addressString)
            .subscribeNext { [weak self] (kiosksResult: FetchResult<KioskResult>) in
                guard let `self` = self else { return }
                switch kiosksResult {
                case .NetworkError(let error):
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
                case .Success(let result):
                    logInfo("fetched kiosks: \(result.kiosks)")
                    self.kiosks = result.kiosks
                    self.castView.updateKiosks(result.kiosks)
                    self.castView.switcherState = .Success
                    self.castView.geocodingErrorVisible = false
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: EditKioskViewDelegate
    
    func editKioskView(view: EditKioskView, didReturnSearchString searchString: String) {
        fetchKiosks(withAddressString: searchString)
    }
    
    func editKioskView(view: EditKioskView, didChooseKioskAtIndex kioskIndex: Int) {
        guard let kiosks = kiosks else { return }
        delegate?.editKioskViewControllerDidChooseKiosk(self, kiosk: kiosks[kioskIndex])
    }
    
    // MARK: ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchKiosks(withAddressString: castView.searchString)
    }

    // MARK: Utilities
    
    func kioskSearchString(fromClientAddress clientAddress: [AddressFormField]) -> String {
        var strings = [String]()
        for addressField in clientAddress {
            switch addressField {
            case .StreetAndApartmentNumbers(let value?): strings.append(value)
            case .City(let value?): strings.append(value)
            default: break
            }
        }
        return strings.joinWithSeparator(", ")
    }
}


