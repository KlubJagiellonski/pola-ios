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

class ApiService {
    let networkClient: NetworkClient
    weak var dataSource: ApiServiceDataSource?
    weak var delegate: ApiServiceDelegate?
    
    var basePath: String {
        return Constants.baseUrl
    }
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

enum ApiError: ErrorType {
    case NoSession
    case LoginRetryFailed
}

extension ApiService {
    func fetchContentPromo(withGender gender: Gender) -> Observable<ContentPromoResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("home")
            .URLByAppendingParams(["gender": gender.rawValue])
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<ContentPromoResult> in
                do {
                    let array = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [AnyObject]
                    return Observable.just(try ContentPromoResult.decode(array))
                } catch {
                    return Observable.error(error)
                }
        }
    }
    
    func fetchProductDetails(withProductId productId: Int) -> Observable<ProductDetails> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("products")
            .URLByAppendingPathComponent(String(productId))
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<ProductDetails> in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try ProductDetails.decode(result))
                } catch {
                    return Observable.error(error)
                }
        }
    }
    
    func fetchSearchCatalogue() -> Observable<SearchResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("search_catalogue")
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<SearchResult> in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try SearchResult.decode(result))
                } catch {
                    return Observable.error(error)
                }
        }
    }
    
    func validateBasket(with basketRequest: BasketRequest) -> Observable<Basket> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("cart/validate")
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(basketRequest.encode(), options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<Basket> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try Basket.decode(result))
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func fetchProducts(with request: ProductRequest) -> Observable<ProductListResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("products")
        
        do {
            let requestBody = request.encode()
            logInfo("Sentding products request with body: \(requestBody)")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(requestBody, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<ProductListResult> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try ProductListResult.decode(result))
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func fetchTrend(slug: String) -> Observable<ProductListResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("trend")
            .URLByAppendingPathComponent(slug)
        
        logInfo("Sending trend \(slug)")
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<ProductListResult> in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try ProductListResult.decode(result))
                } catch {
                    return Observable.error(error)
                }
        }
    }
    
    func fetchBrand(forBrandId brandId: Int, request: ProductRequest) -> Observable<ProductListResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("store")
            .URLByAppendingPathComponent(String(brandId))
        
        do {
            let requestBody = request.encode()
            logInfo("Sentding brand \(brandId) products request with body: \(requestBody)")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(requestBody, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<ProductListResult> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try ProductListResult.decode(result))
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }

    func fetchKiosks(withLatitude latitude: Double, longitude: Double, limit: Int = 10) -> Observable<KioskResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("delivery/pwr/pops")
            .URLByAppendingParams(["limit": String(limit)])
        
        do {
            let paramsDict = ["lat": latitude, "lng": longitude] as NSDictionary
            let jsonData = try NSJSONSerialization.dataWithJSONObject(paramsDict, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<KioskResult> in
                    do {
                        let array = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [AnyObject]
                        return Observable.just(try KioskResult.decode(array))
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func fetchSettingsWebContent(settingsWebType settingsWebType: SettingsWebType, retryOnNotLoggedIn: Bool = true) -> Observable<WebContentResult> {        
        let session = dataSource?.apiServiceWantsSession(self)
        if session == nil && settingsWebType.requiresSession {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath).URLByAppendingPathComponent(settingsWebType.pathComponent)
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        
        if settingsWebType.requiresSession {
            urlRequest.applySessionHeaders(session!)
        }
    
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .flatMap { data -> Observable<WebContentResult> in
                let result = String(data: data, encoding: NSUTF8StringEncoding)
                return Observable.just(result ?? "")
            }.catchError { [unowned self] error -> Observable<WebContentResult> in
                return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) { [unowned self] (Void) -> Observable<WebContentResult> in
                    return self.fetchSettingsWebContent(settingsWebType: settingsWebType, retryOnNotLoggedIn: false)
                }
            }
    }
    
    func fetchUser(retryOnNotLoggedIn: Bool = true) -> Observable<User> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("user/profile")
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        urlRequest.applySessionHeaders(session)
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<User> in
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try User.decode(dict))
                } catch {
                    return Observable.error(error)
                }
        }.catchError { [unowned self] error -> Observable<User> in
            return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) { [unowned self] (Void) -> Observable<User> in return self.fetchUser(false) }
        }
    }
    
    func addUserAddress(address: EditUserAddress) -> Observable<UserAddress>{
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("user/address")
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(address.encode(), options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "PUT"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            urlRequest.applySessionHeaders(session)
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<UserAddress> in
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try UserAddress.decode(dict))
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func editUserAddress(forId id: ObjectId, address: EditUserAddress) -> Observable<UserAddress>{
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("user/address")
            .URLByAppendingPathComponent(String(id))
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(address.encode(), options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            urlRequest.applySessionHeaders(session)
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<UserAddress> in
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try UserAddress.decode(dict))
                    } catch {
                        return Observable.error(error)
                    }
                    
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func login(with login: Login) -> Observable<SigningResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("login")
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(login.encode(), options: [])
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<SigningResult> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        let loginResult = try SigningResult.decode(result)
                        return Observable.just(loginResult)
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func register(with registration: Registration) -> Observable<SigningResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("register")
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(registration.encode(), options: [])
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<SigningResult> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        let registrationResult = try SigningResult.decode(result)
                        return Observable.just(registrationResult)
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func loginWithFacebook(with facebookLogin: FacebookLogin) -> Observable<SigningResult> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("login/facebook")
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(facebookLogin.encode(), options: [])
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<SigningResult> in
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        let loginResult = try SigningResult.decode(result)
                        return Observable.just(loginResult)
                    } catch {
                        return Observable.error(error)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func authorizePayment(withProvider provider: PaymentAuthorizeProvider, retryOnNotLoggedIn: Bool = true) -> Observable<PaymentAuthorizeResult> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("payment")
            .URLByAppendingPathComponent(provider.rawValue)
            .URLByAppendingPathComponent("authorize")
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        urlRequest.applySessionHeaders(session)
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<PaymentAuthorizeResult> in
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try PaymentAuthorizeResult.decode(dict))
                } catch {
                    return Observable.error(error)
                }
        }.catchError { [unowned self] error -> Observable<PaymentAuthorizeResult> in
                return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) {
                    [unowned self](Void) -> Observable<PaymentAuthorizeResult> in
                    return self.authorizePayment(withProvider: provider, retryOnNotLoggedIn: false)
                }
        }
    }
    
    func deleteFromWishlist(with param: SingleWishlistRequest, retryOnNotLoggedIn: Bool = true) -> Observable<WishlistResult> {
        return wishlistRequest(with: param, method: "DELETE", retryOnNotLoggedIn: retryOnNotLoggedIn) {
            [unowned self](Void) -> Observable<WishlistResult> in
            return self.deleteFromWishlist(with: param, retryOnNotLoggedIn: false)
        }
    }
    
    func fetchWishlist(retryOnNotLoggedIn retryOnNotLoggedIn: Bool = true) -> Observable<WishlistResult> {
        return wishlistRequest(with: nil, method: "GET", retryOnNotLoggedIn: retryOnNotLoggedIn) {
            [unowned self](Void) -> Observable<WishlistResult> in
            return self.fetchWishlist(retryOnNotLoggedIn: false)
        }
    }
    
    func addToWishlist(with param: SingleWishlistRequest, retryOnNotLoggedIn: Bool = true) -> Observable<WishlistResult> {
        return wishlistRequest(with: param, method: "PUT", retryOnNotLoggedIn: retryOnNotLoggedIn) {
            [unowned self](Void) -> Observable<WishlistResult> in
            return self.addToWishlist(with: param, retryOnNotLoggedIn: false)
        }
    }
    
    func sendWishlist(with param: MultipleWishlistRequest, retryOnNotLoggedIn: Bool = true) -> Observable<WishlistResult> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("user/wishlist/multiple")
        
        do {
            let encodedParam = param.encode()
            logInfo("Sending wishlist request with param: \(encodedParam)")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(encodedParam, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            urlRequest.applySessionHeaders(session)
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<WishlistResult> in
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try WishlistResult.decode(dict))
                    } catch {
                        return Observable.error(error)
                    }
            }.catchError { [unowned self] error -> Observable<WishlistResult> in
                    return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) {
                        [unowned self](Void) -> Observable<WishlistResult> in
                        return self.sendWishlist(with: param, retryOnNotLoggedIn: false)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func createPayment(with param: PaymentRequest, retryOnNotLoggedIn: Bool = true) -> Observable<PaymentResult> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("payment")
        
        do {
            let encodedParam = param.encode()
            logInfo("Sending payment request with param: \(encodedParam)")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(encodedParam, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "PUT"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            urlRequest.applySessionHeaders(session)
            return networkClient
                .request(withRequest: urlRequest)
                .logNetworkError()
                .flatMap { data -> Observable<PaymentResult> in
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        return Observable.just(try PaymentResult.decode(dict))
                    } catch {
                        return Observable.error(error)
                    }
                }.catchError { [unowned self] error -> Observable<PaymentResult> in
                    return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn) {
                        [unowned self](Void) -> Observable<PaymentResult> in
                        return self.createPayment(with: param, retryOnNotLoggedIn: false)
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    func logout() -> Observable<Void> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("logout")
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "DELETE"
        urlRequest.applyJsonContentTypeHeader()
        urlRequest.applySessionHeaders(session)
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<Void> in
                return Observable.just()
        }
    }
    
    func resetPassword(withEmail email: String) -> Observable<Void> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("reset-password")
        
        do {
            let param = ["email": email] as NSDictionary
            logInfo("Sending reset password request with param: \(param)")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(param, options: [])
            
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = jsonData
            urlRequest.applyJsonContentTypeHeader()
            return networkClient.request(withRequest: urlRequest)
                .logNetworkError()
                .handleAppNotSupportedError(self)
                .flatMap { data -> Observable<Void> in
                    return Observable.just()
            }
        } catch {
            return Observable.error(error)
        }
    }
    
    private func catchNotAuthorizedError<T>(error: ErrorType, shouldRetry: Bool, retryCall: Void -> Observable<T>) throws -> Observable<T> {
        guard shouldRetry else { return Observable.error(error) }
        guard let dataSource = dataSource, let urlError = error as? RxCocoaURLError else { return Observable.error(error) }
        guard case let .HTTPRequestFailed(response, _) = urlError where response.statusCode == 401 else { return Observable.error(error) }
        
        return dataSource.apiServiceWantsHandleLoginRetry(self)
            .flatMap { Void -> Observable<T> in
                return Observable<T>.create { observer in
                    return retryCall().subscribe(observer)
                }
        }
    }
    
    private func wishlistRequest(with param: SingleWishlistRequest?, method: String, retryOnNotLoggedIn: Bool, retryCall: Void -> Observable<WishlistResult>) -> Observable<WishlistResult> {
        guard let session = dataSource?.apiServiceWantsSession(self) else {
            return Observable.error(ApiError.NoSession)
        }
        
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("user/wishlist")
        
        var jsonData: NSData?
        if let param = param {
            do {
                let encodedParam = param.encode()
                logInfo("Sendind wishlist request with param: \(encodedParam)")
                jsonData = try NSJSONSerialization.dataWithJSONObject(encodedParam, options: [])
            } catch {
                return Observable.error(error)
            }
        }
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = method
        urlRequest.HTTPBody = jsonData
        urlRequest.applySessionHeaders(session)
        urlRequest.applyJsonContentTypeHeader()
        return networkClient
            .request(withRequest: urlRequest)
            .logNetworkError()
            .handleAppNotSupportedError(self)
            .flatMap { data -> Observable<WishlistResult> in
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return Observable.just(try WishlistResult.decode(dict))
                } catch {
                    return Observable.error(error)
                }
        }.catchError { [unowned self] error -> Observable<WishlistResult> in
                return try self.catchNotAuthorizedError(error, shouldRetry: retryOnNotLoggedIn, retryCall: retryCall)
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

extension NSURL {
    func URLByAppendingParams(params: [String: String]) -> NSURL {
        var url = self.absoluteString
        url += url.containsString("?") ? "&" : "?"
        for (key, value) in params {
            url += key + "=" + value + "&"
        }
        url = url.substringToIndex(url.endIndex.predecessor())
        return NSURL(string: url)!
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

extension SettingsWebType {
    var pathComponent: String {
        switch self {
        case .UserData: return "user/profile"
        case .History: return "order/history"
        case .HowToMeasure: return "how-to-measure"
        case .PrivacyPolicy: return "privacy-policy"
        case .FrequestQuestions: return "faq"
        case .Rules: return "rules"
        case .Contact: return "contact"
        }
    }
    var requiresSession: Bool {
        switch self {
        case UserData, History: return true
        default: return false
        }
    }
}