import Foundation
import RxSwift
import RxCocoa

protocol NetworkClient {
    func request(withRequest urlRequest: NSURLRequest) -> Observable<NSData>
    func invalidateSession()
}

protocol NetworkActivityIndicatorController {
    var networkActivityIndicatorVisible: Bool { get set }
}

class HttpClient: NetworkClient {
    private var numberOfCallsToSetVisible = 0
    private var session: NSURLSession
    
    private(set) var activityIndicatorController: NetworkActivityIndicatorController
    
    init(activityIndicatorController: NetworkActivityIndicatorController) {
        self.session = NSURLSession.createSession()
        self.activityIndicatorController = activityIndicatorController
    }
    
    func request(withRequest urlRequest: NSURLRequest) -> Observable<NSData> {
        return Observable.create {
            [unowned self] observer in
            
            logInfo("Sending request: \(urlRequest)")
            
            self.setNetworkActivityIndicatorVisible(true)
            
            let disposable = self.session.rx_data(urlRequest)
                .doOnNext({ _ in logInfo("Response received: \(urlRequest)") })
                .subscribe(onNext: observer.onNext, onCompleted: observer.onCompleted, onError: observer.onError, onDisposed: {
                    self.setNetworkActivityIndicatorVisible(false)
            })
            
            return disposable
        }
    }
 
    func invalidateSession() {
        session.invalidateAndCancel()
        session = NSURLSession.createSession()
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

extension NSURLSession {
    static func createSession() -> NSURLSession {
        return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
}