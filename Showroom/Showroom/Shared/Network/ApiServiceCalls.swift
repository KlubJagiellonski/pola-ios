import Foundation
import RxSwift

extension ApiService {
    func fetchContentPromo(withGender gender: Gender) -> Observable<ContentPromoResult> {
        let call = ApiServiceCall(
            pathComponent: "home",
            params: ["gender": gender.rawValue],
            httpMethod: .Get,
            authenticationType: .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).decode { try ContentPromoResult.decode($0) }
    }
    
    func fetchProductDetails(withProductId productId: Int) -> Observable<ProductDetails> {
        let call = ApiServiceCall(
            pathComponent: "products/\(productId)",
            params: nil,
            httpMethod: .Get,
            authenticationType: .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).decode { try ProductDetails.decode($0) }
    }
    
    func fetchSearchCatalogue() -> Observable<SearchResult> {
        let call = ApiServiceCall(
            pathComponent: "search-catalogue",
            params: nil,
            httpMethod: .Get,
            authenticationType: .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).decode { try SearchResult.decode($0) }
    }
    
    func fetchAppVersion() -> Observable<AppVersion> {
        let call = ApiServiceCall(
            pathComponent: "app-recent-version",
            params: nil,
            httpMethod: .Get,
            authenticationType: .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).decode { try AppVersion.decode($0) }
    }
    
    func validateBasket(with basketRequest: BasketRequest) -> Observable<Basket> {
        let call = ApiServiceCall(
            pathComponent: "cart/validate",
            params: nil,
            httpMethod: .Post,
            authenticationType: .Optional,
            jsonData: basketRequest.encode()
        )
        return makeCall(with: call).decode { try Basket.decode($0) }
    }
    
    func fetchProducts(with request: ProductRequest) -> Observable<ProductListResult> {
        let call = ApiServiceCall(
            pathComponent: "products",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: request.encode()
        )
        return makeCall(with: call).decode { try ProductListResult.decode($0) }
    }
    
    func fetchTrend(slug: String) -> Observable<ProductListResult> {
        let call = ApiServiceCall(
            pathComponent: "trend/\(slug)",
            params: nil,
            httpMethod: .Get,
            authenticationType: .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).decode { try ProductListResult.decode($0) }
    }
    
    func fetchBrand(forBrandId brandId: Int, request: ProductRequest) -> Observable<ProductListResult> {
        let call = ApiServiceCall(
            pathComponent: "store/\(brandId)",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: request.encode()
        )
        return makeCall(with: call).decode { try ProductListResult.decode($0) }
    }
    
    func fetchKiosks(withLatitude latitude: Double, longitude: Double, limit: Int = 10) -> Observable<KioskResult> {
        let call = ApiServiceCall(
            pathComponent: "delivery/pwr/pops",
            params: ["limit": String(limit)],
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: ["lat": latitude, "lng": longitude] as NSDictionary
        )
        return makeCall(with: call).decode { try KioskResult.decode($0) }
    }
    
    func fetchSettingsWebContent(settingsWebType settingsWebType: SettingsWebType) -> Observable<WebContentResult> {
        let call = ApiServiceCall(
            pathComponent: settingsWebType.pathComponent,
            params: nil,
            httpMethod: .Get,
            authenticationType: settingsWebType.requiresSession ? .Required : .NotRequired,
            jsonData: nil
        )
        return makeCall(with: call).flatMap { data -> Observable<WebContentResult> in
            let result = String(data: data, encoding: NSUTF8StringEncoding)
            return Observable.just(result ?? "")
        }
    }
    
    func fetchUser() -> Observable<User> {
        let call = ApiServiceCall(
            pathComponent: "user/profile",
            params: nil,
            httpMethod: .Get,
            authenticationType: .Required,
            jsonData: nil
        )
        return makeCall(with: call).decode { try User.decode($0) }
    }
    
    func addUserAddress(address: EditUserAddress) -> Observable<UserAddress>{
        let call = ApiServiceCall(
            pathComponent: "user/address",
            params: nil,
            httpMethod: .Put,
            authenticationType: .Required,
            jsonData: address.encode()
        )
        return makeCall(with: call).decode { try UserAddress.decode($0) }
    }
    
    func editUserAddress(forId id: ObjectId, address: EditUserAddress) -> Observable<UserAddress>{
        let call = ApiServiceCall(
            pathComponent: "user/address/\(id)",
            params: nil,
            httpMethod: .Post,
            authenticationType: .Required,
            jsonData: address.encode()
        )
        return makeCall(with: call).decode { try UserAddress.decode($0) }
    }
    
    func login(with login: Login) -> Observable<SigningResult> {
        let call = ApiServiceCall(
            pathComponent: "login",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: login.encode()
        )
        return makeCall(with: call).decode { try SigningResult.decode($0) }
    }
    
    func register(with registration: Registration) -> Observable<SigningResult> {
        let call = ApiServiceCall(
            pathComponent: "register",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: registration.encode()
        )
        return makeCall(with: call).decode { try SigningResult.decode($0) }
    }
    
    func loginWithFacebook(with facebookLogin: FacebookLogin) -> Observable<SigningResult> {
        let call = ApiServiceCall(
            pathComponent: "login/facebook",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: facebookLogin.encode()
        )
        return makeCall(with: call).decode { try SigningResult.decode($0) }
    }
    
    func authorizePayment(withProvider provider: PaymentAuthorizeProvider) -> Observable<PaymentAuthorizeResult> {
        let call = ApiServiceCall(
            pathComponent: "payment/\(provider.rawValue)/authorize",
            params: nil,
            httpMethod: .Get,
            authenticationType: .Required,
            jsonData: nil
        )
        return makeCall(with: call).decode { try PaymentAuthorizeResult.decode($0) }
    }
    
    func createPayment(with param: PaymentRequest) -> Observable<PaymentResult> {
        let call = ApiServiceCall(
            pathComponent: "payment",
            params: nil,
            httpMethod: .Put,
            authenticationType: .Required,
            jsonData: param.encode()
        )
        return makeCall(with: call).decode { try PaymentResult.decode($0) }
    }
    
    func logout() -> Observable<Void> {
        let call = ApiServiceCall(
            pathComponent: "logout",
            params: nil,
            httpMethod: .Delete,
            authenticationType: .Required,
            jsonData: nil
        )
        return makeCall(with: call).flatMap { data -> Observable<Void> in
            return Observable.just()
        }
    }
    
    func resetPassword(withEmail email: String) -> Observable<Void> {
        let call = ApiServiceCall(
            pathComponent: "reset-password",
            params: nil,
            httpMethod: .Post,
            authenticationType: .NotRequired,
            jsonData: ["email": email] as NSDictionary
        )
        return makeCall(with: call).decode { try PaymentResult.decode($0) }
    }
    
    func pushToken(with request: PushTokenRequest) -> Observable<Void> {
        let call = ApiServiceCall(
            pathComponent: "push-token",
            params: nil,
            httpMethod: .Post,
            authenticationType: .Optional,
            jsonData: request.encode()
        )
        return makeCall(with: call).flatMap { data -> Observable<Void> in
            return Observable.just()
        }
    }
    
    func deleteFromWishlist(with param: SingleWishlistRequest) -> Observable<WishlistResult> {
        return wishlistRequest(with: param, method: .Delete)
    }
    
    func fetchWishlist() -> Observable<WishlistResult> {
        return wishlistRequest(with: nil, method: .Get)
    }
    
    func addToWishlist(with param: SingleWishlistRequest) -> Observable<WishlistResult> {
        return wishlistRequest(with: param, method: .Put)
    }
    
    func sendWishlist(with param: MultipleWishlistRequest) -> Observable<WishlistResult> {
        let call = ApiServiceCall(
            pathComponent: "user/wishlist/multiple",
            params: nil,
            httpMethod: .Post,
            authenticationType: .Required,
            jsonData: param.encode()
        )
        return makeCall(with: call).decode { try WishlistResult.decode($0) }
    }
    
    private func wishlistRequest(with param: SingleWishlistRequest?, method: ApiServiceHttpMethod) -> Observable<WishlistResult> {
        let call = ApiServiceCall(
            pathComponent: "user/wishlist",
            params: nil,
            httpMethod: method,
            authenticationType: .Required,
            jsonData: param?.encode()
        )
        return makeCall(with: call).decode { try WishlistResult.decode($0) }
    }
}

extension SettingsWebType {
    var pathComponent: String {
        switch self {
        case .UserData: return "user-profile"
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