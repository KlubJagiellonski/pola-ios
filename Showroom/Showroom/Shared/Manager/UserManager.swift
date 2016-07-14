import Foundation
import RxSwift
import RxCocoa
import Decodable

class UserManager {
    private static let skipStartScreenKey = "SkipStartScreen"
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    let userObservable = PublishSubject<User?>()
    let genderObservable = PublishSubject<Gender>()
    
    private(set) var user: User? {
        didSet { userObservable.onNext(user) }
    }
    var gender: Gender = .Female {
        didSet { genderObservable.onNext(gender) }
    }
    
    var shouldSkipStartScreen: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(UserManager.skipStartScreenKey);
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserManager.skipStartScreenKey);
        }
    }
    
    init(apiService: ApiService) {
        self.apiService = apiService
        let mockedUserAddresses = [
            UserAddress(firstName: "Jan", lastName: "Kowalski", streetAndAppartmentNumbers: "Sikorskiego 12/30", postalCode: "15-888", city: "Białystok", country: "POLSKA", phone: "+48 501 123 456", description: "opis 1"),
            UserAddress(firstName: "Anna", lastName: "Kowalska", streetAndAppartmentNumbers: "Piękna 5/10", postalCode: "02-758", city: "Warszawa", country: "POLSKA", phone: "+48 788 123 456", description: "opis 2")
        ]
        self.user = User(id: 123456789, name: "Jan", email: "jan.kowalski@gmail.com", userAddresses: mockedUserAddresses)
    }
    
    func login(withEmail email: String, password: String) -> Observable<SigningResult> {
        return apiService.login(withEmail: email, password: password)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let strongSelf = self {
                    strongSelf.user = result.user
                }
        }
            .catchError { [weak self] error in
                if let strongSelf = self {
                    strongSelf.user = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown)
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        logInfo(validtionError.message)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    case 401:
                        // Invalid credentials
                        return Observable.error(SigningError.InvalidCredentials)
                    default:
                        return Observable.error(SigningError.Unknown)
                    }
                default:
                    return Observable.error(SigningError.Unknown)
                }
        }
    }
    
    
    func register(withName name: String, email: String, password: String, receiveNewsletter: Bool) -> Observable<SigningResult> {
        return apiService.register(withName: name, email: email, password: password, receiveNewsletter: receiveNewsletter)
        .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let strongSelf = self {
                    strongSelf.user = result.user
                }
        }
            .catchError { [weak self] error in
                if let strongSelf = self {
                    strongSelf.user = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown)
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        logInfo(validtionError.message)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    default:
                        return Observable.error(SigningError.Unknown)
                    }
                default:
                    return Observable.error(SigningError.Unknown)
                }
        }
    }
    
    func logout() {
        self.user = nil
        // TODO: Remove login token from storage
    }
}

enum Gender: String {
    case Male = "male"
    case Female = "female"
}