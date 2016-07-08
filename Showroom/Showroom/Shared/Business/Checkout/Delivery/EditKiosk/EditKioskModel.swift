import UIKit
import CoreLocation
import RxSwift

class EditKioskModel {
    private let api: ApiService
    private let geocoder = CLGeocoder()
    private let disposeBag = DisposeBag()
    let checkoutModel: CheckoutModel
    
    private(set) var kiosks: [Kiosk]?
    
    init(with api: ApiService, and checkoutModel: CheckoutModel) {
        self.api = api
        self.checkoutModel = checkoutModel
    }
    
    func fetchKiosks(withLatitude latitude: Double, longitude: Double, limit: Int = 10) -> Observable<FetchResult<KioskResult>> {
        return api.fetchKiosks(withLatitude: latitude, longitude: longitude, limit: limit)
            .doOnNext { [weak self] in self?.kiosks = $0.kiosks }
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
    }
    
    func fetchKiosks(withAddressString addressString: String) -> Observable<FetchResult<KioskResult>> {
        
        return geocoder.rx_geocodeAddressString(addressString)
            .flatMap { [weak self](placemarks: [CLPlacemark]) -> Observable<FetchResult<KioskResult>> in
                guard let `self` = self else { return Observable.empty() }
                if let coordinates = placemarks.first?.location?.coordinate {
                    return self.fetchKiosks(withLatitude: coordinates.latitude, longitude: coordinates.longitude)
                } else {
                    return Observable.just(FetchResult.Success(KioskResult(kiosks: [])))
                }
        }
        .catchError { error in
            return Observable.just(FetchResult.NetworkError(error))
        }
    }
}
