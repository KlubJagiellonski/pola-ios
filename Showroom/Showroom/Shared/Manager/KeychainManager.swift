import Foundation
import Security
import RxSwift

// taken from http://stackoverflow.com/questions/25513106/trying-to-use-keychainitemwrapper-by-apple-translated-to-swift

class KeychainManager: NSObject {
    private let secClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    private let secClassValue = NSString(format: kSecClass)
    private let secAttrServiceValue = NSString(format: kSecAttrService)
    private let secValueDataValue = NSString(format: kSecValueData)
    private let secMatchLimitValue = NSString(format: kSecMatchLimit)
    private let secReturnDataValue = NSString(format: kSecReturnData)
    private let secMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
    private let secAttrAccountValue = NSString(format: kSecAttrAccount)
    
    func setPasscode(identifier: String, passcode: String?) {
        logInfo("Saving passcode for identifier \(identifier)")
        let pass = passcode ?? ""
        let dataFromString: NSData = pass.dataUsingEncoding(NSUTF8StringEncoding)!
        let keychainQuery = NSDictionary(
            objects: [secClassGenericPasswordValue, identifier, dataFromString],
            forKeys: [secClassValue, secAttrServiceValue, secValueDataValue])
        SecItemDelete(keychainQuery as CFDictionaryRef)
        let status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
        logInfo("Saved passcode with status \(status)")
    }
    
    func getPasscode(identifier: String) -> String? {
        logInfo("Retrieving passcode for identifier \(identifier)")
        let keychainQuery = NSDictionary(
            objects: [secClassGenericPasswordValue, identifier, kCFBooleanTrue, secMatchLimitOneValue],
            forKeys: [secClassValue, secAttrServiceValue, secReturnDataValue, secMatchLimitValue])
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var passcode: NSString?
        if (status == errSecSuccess) {
            let retrievedData: NSData? = dataTypeRef as? NSData
            if let result = NSString(data: retrievedData!, encoding: NSUTF8StringEncoding) {
                passcode = result as String
            }
        } else {
            logInfo("Nothing was retrieved from the keychain. Status code \(status)")
        }
        if passcode?.length == 0 {
            passcode = nil
        }
        return passcode as? String
    }
    
    func fetchSharedWebCredentials() -> Observable<SharedWebCredential> {
        return Observable.create { observer in
            SecRequestSharedWebCredential(Constants.websiteDomain, nil) { array, error in
                if let array = array as Array?, dictionary = array.first as? NSDictionary, let credential = SharedWebCredential(dictionary: dictionary) {
                    observer.onNext(credential)
                } else {
                    observer.onError(SharedWebCredentialsError.Unknown(error))
                }
                observer.onCompleted()
            }
            
            return NopDisposable.instance
        }
    }
    
    func addSharedWebCredentials(credentials: SharedWebCredential) -> Observable<Void> {
        return Observable.create { observer in
            SecAddSharedWebCredential(Constants.websiteDomain, credentials.account, credentials.password) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext()
                }
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
}