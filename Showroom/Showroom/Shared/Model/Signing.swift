import Foundation
import Decodable
import Foundation

struct Login {
    let username: String
    let password: String
}

struct FacebookLogin {
    let accessToken: String
}

struct Registration {
    let name: String
    let username: String
    let password: String
    let newsletter: Bool
    let gender: String
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

struct Session {
    let userKey: String
    let userSecret: String
}

struct SharedWebCredential {
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
}

// MARK: - Errors

enum SigningError: ErrorType {
    case ValidationFailed(SigningFieldsErrors)
    case InvalidCredentials
    case FacebookError(NSError)
    case FacebookCancelled
    case Unknown
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

enum SharedWebCredentialsError: ErrorType {
    case Unknown(CFError?)
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
            "gender": gender
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