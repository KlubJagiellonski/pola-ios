import Foundation
import RxSwift
import RxCocoa

protocol ApiServiceDataSource: class {
    func apiServiceWantsSession(api: ApiService) -> Session?
    func apiServiceWantsHandleLoginRetry(api: ApiService) -> Observable<Void>
}

protocol ApiServiceDelegate: class {
    func apiServiceDidReceiveAppNotSupportedError(api: ApiService)
}

enum ApiError: ErrorType {
    case NoBasePath
    case NoSession
    case LoginRetryFailed
}

class ApiService {
    private let networkClient: NetworkClient
    weak var dataSource: ApiServiceDataSource?
    weak var delegate: ApiServiceDelegate?
    var configuration: ApiServiceConfiguration? {
        didSet {
            networkClient.invalidateSession()
        }
    }
    
    var basePath: String? {
        guard let configuration = configuration else {
            return nil
        }
        return configuration.path
    }
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func makeCall(with call: ApiServiceCall, retryOnNotLoggedIn: Bool = true) -> Observable<NSData> {
        guard let basePath = basePath else {
            return Observable.error(ApiError.NoBasePath)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent(call.pathComponent)
            .URLByAppendingParams(call.params)
        
        logInfo("Making call to url: \(url)")
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = call.httpMethod.rawValue
        if call.authenticationType == .Required {
            guard let session = dataSource?.apiServiceWantsSession(self) else {
                logInfo("Cannot make call, no session")
                return Observable.error(ApiError.NoSession)
            }
            urlRequest.applySessionHeaders(session)
        } else if let session = dataSource?.apiServiceWantsSession(self) where call.authenticationType == .Optional {
            urlRequest.applySessionHeaders(session)
        }
        
        if let jsonData = call.jsonData {
            urlRequest.applyJsonContentTypeHeader()
            logInfo("Making call \(url) with data \(jsonData)")
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(jsonData, options: [])
                urlRequest.HTTPBody = data
            } catch {
                logError("Cannot parse to json \(jsonData) for url \(url)")
                return Observable.error(error)
            }
            
        }
        let requestObservable = networkClient.request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
        
        if call.authenticationType == .Required {
            return requestObservable.catchError { [unowned self] error -> Observable<NSData> in
                return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) { [unowned self] Void -> Observable<NSData> in
                    return self.makeCall(with: call, retryOnNotLoggedIn: false)
                }
            }
        } else {
            return requestObservable
        }
    }
}

// MARK:- Call

enum ApiServiceHttpMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Delete = "DELETE"
}

enum ApiServiceAuthenticationType {
    case Required, NotRequired, Optional
}

struct ApiServiceCall {
    let pathComponent: String
    let params: [String: String]?
    let httpMethod: ApiServiceHttpMethod
    let authenticationType: ApiServiceAuthenticationType
    let jsonData: AnyObject?
}

// MARK:- Configuration

enum ApiServiceVersion: String {
    case V1 = "v1"
}

struct ApiServiceConfiguration {
    let isStagingEnv: Bool
    let platform: Platform
    let version: ApiServiceVersion
    
    var path: String {
        let typeComponent = isStagingEnv ? "api-test" : "api"
        return "https://\(typeComponent).showroom.\(platform.code)/ios/\(version.rawValue)"
    }
    
    init(platform: Platform, isStagingEnv: Bool = Constants.isStagingEnv, version: ApiServiceVersion = .V1) {
        self.isStagingEnv = isStagingEnv
        self.platform = platform
        self.version = version
    }
}

// MARK:- Utilities

extension ApiService {
    func catchNotAuthorizedError<T>(error: ErrorType, shouldRetry: Bool, retryCall: Void -> Observable<T>) throws -> Observable<T> {
        guard shouldRetry else { return Observable.error(error) }
        guard let dataSource = dataSource, let urlError = error as? RxCocoaURLError else { return Observable.error(error) }
        guard case let .HTTPRequestFailed(response, _) = urlError where response.statusCode == 401 else { return Observable.error(error) }
        
        logInfo("Catched not authorized error \(error), shouldRetry \(shouldRetry)")
        
        return dataSource.apiServiceWantsHandleLoginRetry(self)
            .flatMap { Void -> Observable<T> in
                return Observable<T>.create { observer in
                    return retryCall().subscribe(observer)
                }
        }
    }
}

extension NSMutableURLRequest {
    func applySessionHeaders(session: Session) {
        setValue(session.userKey, forHTTPHeaderField: "showroom-key")
        setValue(session.userSecret, forHTTPHeaderField: "showroom-secret")
    }
    func applyJsonContentTypeHeader() {
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

extension ObservableType {
    func logNetworkError() -> Observable<E> {
        return doOnError { error in
            if let cocoaError = error as? RxCocoaURLError {
                switch cocoaError {
                case .HTTPRequestFailed(let response, let data):
                    var dataString: String?
                    if let data = data {
                        dataString = String(data: data, encoding: NSUTF8StringEncoding)
                    }
                    let finalDataString = dataString ?? "(no data)"
                    logInfo("Failed response \(response) with data \(finalDataString)")
                default: break
                }
            }
        }
    }
    
    func handleAppNotSupportedError(apiService: ApiService) -> Observable<E> {
        return doOnError { error in
            guard let urlError = error as? RxCocoaURLError, case let .HTTPRequestFailed(response, _) = urlError where response.statusCode == 410 else {
                return
            }
            logInfo("Received 410")
            apiService.delegate?.apiServiceDidReceiveAppNotSupportedError(apiService)
        }
    }
}

extension Observable where Element: NSData {
    func decode<T>(decodeMethod: AnyObject throws -> T) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                return Observable<T>.just(try decodeMethod(result))
            } catch {
                return Observable<T>.error(error)
            }
        }
    }
}