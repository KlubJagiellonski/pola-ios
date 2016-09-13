import Foundation

protocol KeyValueCache {
    func synchronize() -> Bool
    func setObject(value: AnyObject?, forKey defaultName: String)
    func stringForKey(defaultName: String) -> String?
    func setBool(value: Bool, forKey defaultName: String)
    func boolForKey(defaultName: String) -> Bool
}

extension NSUserDefaults: KeyValueCache { }