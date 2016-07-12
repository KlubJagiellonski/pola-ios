import Foundation
import Decodable
import Foundation

struct Credentials {
    let username: String
    let password: String
}

struct LoginResult {
    let token: String
    let user: User
}

// MARK: - Errors

enum LoginError: ErrorType {
    case ValidationFailed(LoginFieldsErrors)
    case InvalidCredentials
    case Unknown
}

struct LoginValidationError {
    let message: String
    let errors: LoginFieldsErrors
}

struct LoginFieldsErrors {
    let username: String?
    let password: String?
}


// MARK: - Decodable, Encodable

extension Credentials: Encodable {
    func encode() -> AnyObject {
        return [
            "username": username,
            "password": password
            ] as NSDictionary
    }
}

extension LoginResult: Decodable {
    static func decode(json: AnyObject) throws -> LoginResult {
        return try LoginResult(
            token: json => "token",
            user: json => "user")
    }
}

extension LoginValidationError: Decodable {
    static func decode(json: AnyObject) throws -> LoginValidationError {
        return try LoginValidationError(
            message: json => "message",
            errors: json => "errors")
    }
}

extension LoginFieldsErrors: Decodable {
    static func decode(json: AnyObject) throws -> LoginFieldsErrors {
        return try LoginFieldsErrors(
            username: json =>? "username",
            password: json =>? "password")
    }
}