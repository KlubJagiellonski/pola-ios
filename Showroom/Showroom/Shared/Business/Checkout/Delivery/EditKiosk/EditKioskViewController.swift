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
    
    var kiosks: [Kiosk]?
    
    var selectedKioskIndex: Int? {
        get { return castView.selectedKioskIndex }
        set { castView.selectedKioskIndex = newValue }
    }
    
    weak var delegate: EditKioskViewControllerDelegate?
    
    private let resolver: DiResolver
    
    init(resolver: DiResolver, clientAddress: [AddressFormField]) {
        self.resolver = resolver
        self.model = EditKioskModel(api: resolver.resolve(ApiService.self))
        self.clientAddress = clientAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = EditKioskView(kioskSearchString: kioskSearchString(fromClientAddress: clientAddress))
        castView.delegate = self
    }
    
    override func viewDidLoad() {
        fetchKiosks(withAddressString: castView.searchString)
    }
    
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
    
    func editKioskViewDidReturnSearchString(view: EditKioskView, searchString: String) {
        fetchKiosks(withAddressString: searchString)
    }
    
    func editKioskViewDidChooseKioskAtIndex(view: EditKioskView, kioskIndex: Int) {
        guard let kiosks = kiosks else { return }
        delegate?.editKioskViewControllerDidChooseKiosk(self, kiosk: kiosks[kioskIndex])
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchKiosks(withAddressString: castView.searchString)
    }
    
    func fetchKiosks(withAddressString addressString: String) {
        castView.switcherState = .Loading
        
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
                            self.castView.saveButtonEnabled = false
                        case .Network:
                            self.castView.switcherState = .Error
                            self.castView.geocodingErrorVisible = false
                            self.castView.saveButtonEnabled = false
                        case .GeocodeCanceled:
                            break
                        default:
                            self.castView.switcherState = .Success
                            self.castView.geocodingErrorVisible = true
                            self.castView.saveButtonEnabled = false
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
                    self.castView.saveButtonEnabled = true
                }
            }
            .addDisposableTo(disposeBag)
    }
}


