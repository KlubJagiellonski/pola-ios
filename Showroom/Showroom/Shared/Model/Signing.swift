import Foundation
import Decodable
import Foundation

struct Login: CustomStringConvertible{
    let username: String
    let password: String
    
    var description: String {
        return "Login(username: \(username))"
    }
}

struct FacebookLogin: CustomStringConvertible {
    let accessToken: String
    
    var description: String {
        return "FacebookLogin()"
    }
}

struct Registration: CustomStringConvertible {
    let name: String
    let username: String
    let password: String
    let newsletter: Bool
    let gender: Gender
    
    var description: String {
        return "Registration(name: \(name), username: \(username), newsletter: \(newsletter), gender: \(gender))"
    }
}

struct SigningResult {
    let session: Session
    let user: User
}

struct UserSession {
    let user: User
    let session: Session
    
    init?(user: User?, session: Session?) {
        guard let user = user, let session = session else { return nil }
        self.user = user
        self.session = session
    }
 }

struct Session: CustomStringConvertible {
    let userKey: String
    let userSecret: String
 
    var description: String {
        return "Session()"
    }
}

struct SharedWebCredential: CustomStringConvertible {
    let domain: String?
    let account: String
    let password: String?
    
    init(account: String, password: String) {
        self.account = account
        self.password = password
        self.domain = nil
    }
    init?(dictionary: NSDictionary) {
        let dict = dictionary as Dictionary
        
        guard let domain = dict[kSecAttrServer] as? String,
            account = dict[kSecAttrAccount] as? String,
            password = dict[kSecSharedPassword] as? String
            else { return nil }
        
        self.domain = domain
        self.account = account
        self.password = password
    }
    
    var description: String {
        return "SharedWebCredential(domain: \(domain), account: \(account))"
    }
}

// MARK: - Errors

enum SigningError: ErrorType {
    case ValidationFailed(SigningFieldsErrors)
    case InvalidCredentials
    case FacebookError(NSError)
    case FacebookCancelled
    case Unknown(ErrorType)
}

struct SigningValidationError {
    let message: String
    let errors: SigningFieldsErrors
}

struct SigningFieldsErrors {
    let name: String?
    let email: String?
    let username: String?
    let password: String?
    let newsletter: String?
}

// MARK: - Decodable, Encodable

extension Login: Encodable {
    func encode() -> AnyObject {
        return [
            "username": username,
            "password": password
        ] as NSDictionary
    }
}

extension FacebookLogin: Encodable {
    func encode() -> AnyObject {
        return [
            "access_token": accessToken
        ] as NSDictionary
    }
}

extension Registration: Encodable {
    func encode() -> AnyObject {
        return [
            "name": name,
            "email": username,
            "password": password,
            "newsletter": newsletter.description,
            "gender": gender.rawValue
        ] as NSDictionary
    }
}

extension SigningResult: Decodable {
    static func decode(json: AnyObject) throws -> SigningResult {
        return try SigningResult(
            session: json => "session",
            user: json => "user")
    }
}

extension Session: Decodable {
    static func decode(json: AnyObject) throws -> Session {
        return try Session(
            userKey: json => "userKey",
            userSecret: json => "userSecret")
    }
}

extension SigningValidationError: Decodable {
    static func decode(json: AnyObject) throws -> SigningValidationError {
        return try SigningValidationError(
            message: json => "message",
            errors: json => "errors")
    }
}

extension SigningFieldsErrors: Decodable {
    static func decode(json: AnyObject) throws -> SigningFieldsErrors {
        return try SigningFieldsErrors(
            name: json =>? "name",
            email: json =>? "email",
            username: json =>? "username",
            password: json =>? "password",
            newsletter: json =>? "newsletter"
        )
    }
}

// MARK:- Equatable

extension SharedWebCredential: Equatable {}

func ==(lhs: SharedWebCredential, rhs: SharedWebCredential) -> Bool {
    return lhs.account == rhs.account && lhs.password == rhs.password
}
