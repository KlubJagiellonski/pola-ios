import Foundation
import RxSwift
import RxCocoa

protocol NetworkClient {
    func request(withRequest urlRequest: NSURLRequest) -> Observable<NSData>
}

protocol NetworkActivityIndicatorController {
    var networkActivityIndicatorVisible: Bool { get set }
}

class HttpClient: NetworkClient {
    private var numberOfCallsToSetVisible = 0
    private let session: NSURLSession
    
    private(set) var activityIndicatorController: NetworkActivityIndicatorController
    
    init(session: NSURLSession, activityIndicatorController: NetworkActivityIndicatorController) {
        self.session = session
        self.activityIndicatorController = activityIndicatorController
    }
    
    func request(withRequest urlRequest: NSURLRequest) -> Observable<NSData> {
        return Observable.create {
            [unowned self] observer in
            
            logDebug("Sending request: \(urlRequest)")
            
            self.setNetworkActivityIndicatorVisible(true)
            
            let disposable = self.session.rx_data(urlRequest)
                .doOnNext({ _ in logDebug("Response received: \(urlRequest)") })
                .subscribe(onNext: observer.onNext, onCompleted: observer.onCompleted, onError: observer.onError, onDisposed: {
                    self.setNetworkActivityIndicatorVisible(false)
            })
            
            return disposable
        }
    }
    
    private func setNetworkActivityIndicatorVisible(visible: Bool) {
        if visible {
            numberOfCallsToSetVisible += 1
        } else {
            numberOfCallsToSetVisible -= 1
        }
        activityIndicatorController.networkActivityIndicatorVisible = numberOfCallsToSetVisible > 0
    }
}