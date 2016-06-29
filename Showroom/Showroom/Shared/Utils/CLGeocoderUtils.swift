import CoreLocation
import RxSwift

public extension CLGeocoder {
    
    func rx_reverseGeocode(location: CLLocation) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            geocodeHandler(observer, geocode: curry2(self.reverseGeocodeLocation, location))
            return AnonymousDisposable { self.cancelGeocode() }
        }
    }
    
    func rx_geocodeAddressDictionary(addressDictionary: [NSObject : AnyObject]) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            geocodeHandler(observer, geocode: curry2(self.geocodeAddressDictionary, addressDictionary))
            return AnonymousDisposable { self.cancelGeocode() }
        }
    }
    
    func rx_geocodeAddressString(addressString: String) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            geocodeHandler(observer, geocode: curry2(self.geocodeAddressString, addressString))
            return AnonymousDisposable { self.cancelGeocode() }
        }
    }
    
    func rx_geocodeAddressString(addressString: String, inRegion region: CLRegion?) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            geocodeHandler(observer, geocode: curry3(self.geocodeAddressString, addressString, region))
            return AnonymousDisposable { self.cancelGeocode() }
        }
    }
}

private func curry2<A, B, C>(f: (A, B) -> C, _ a: A) -> B -> C {
    return { b in f(a, b) }
}

private func curry3<A, B, C, D>(f: (A, B, C) -> D, _ a: A, _ b: B) -> C -> D {
    return { c in f(a, b, c) }
}

private func geocodeHandler(observer: AnyObserver<[CLPlacemark]>, geocode: (CLGeocodeCompletionHandler) -> Void) {
    let semaphore = dispatch_semaphore_create(0)
    dispatch_async(waitForCompletionQueue) {
        geocode { placemarks, error in
            dispatch_semaphore_signal(semaphore)
            if let placemarks = placemarks {
                observer.onNext(placemarks)
                observer.onCompleted()
            }
            else if let error = error {
                observer.onError(error)
            }
            else {
                observer.onError(RxError.Unknown)
            }
        }
        let waitUntil = dispatch_time(DISPATCH_TIME_NOW, Int64(30 * Double(NSEC_PER_SEC)))
        dispatch_semaphore_wait(semaphore, waitUntil)
    }
}

private let waitForCompletionQueue = dispatch_queue_create("WaitForGeocodeCompletionQueue", nil)