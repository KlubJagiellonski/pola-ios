//  Created by Daniel Tartaglia on 5/7/16.
//  Copyright © 2016 Daniel Tartaglia. MIT License.
//  https://gist.github.com/dtartaglia/64bda2a32c18b8c28e1e22085a05df5a

import CoreLocation
import RxSwift

public extension CLGeocoder {

    func rx_geocodeAddressString(addressString: String) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            geocodeHandler(observer, geocode: curry2(self.geocodeAddressString, addressString))
            return AnonymousDisposable { self.cancelGeocode() }
        }
    }
}

private func curry2<A, B, C>(f: (A, B) -> C, _ a: A) -> B -> C {
    return { b in f(a, b) }
}

private func geocodeHandler(observer: AnyObserver<[CLPlacemark]>, geocode: (CLGeocodeCompletionHandler) -> Void) {
    logInfo("Handling geocoder")
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