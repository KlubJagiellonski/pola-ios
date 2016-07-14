import Foundation
import Decodable
import Foundation

struct Login {
    let username: String
    let password: String
}

struct Registration {
    let name: String
    let username: String
    let password: String
    let newsletter: Bool
}

struct SigningResult {
    let token: String
    let user: User
}

// MARK: - Errors

enum SigningError: ErrorType {
    case ValidationFailed(SigningFieldsErrors)
    case InvalidCredentials
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


// MARK: - Decodable, Encodable

extension Login: Encodable {
    func encode() -> AnyObject {
        return [
            "username": username,
            "password": password
            ] as NSDictionary
    }
}

extension Registration: Encodable {
    func encode() -> AnyObject {
        return [
            "name": name,
            "email": username,
            "password": password,
            "newsletter": newsletter.description
        ] as NSDictionary
    }
}

extension SigningResult: Decodable {
    static func decode(json: AnyObject) throws -> SigningResult {
        return try SigningResult(
            token: json => "token",
            user: json => "user")
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