import Foundation
import Decodable

protocol Encodable {
    func encode() -> AnyObject
}

enum StorageType {
    case Cache
    case Persistent
    case PlatformPersistent
}

protocol KeyValueStorage {
    func saveObject(object: AnyObject?, forKey key: String) -> Bool
    func loadObject(forKey key: String) -> AnyObject?
    func save<T: Encodable>(object: T?, forKey key: String, type: StorageType) -> Bool
    func load<T: Decodable>(forKey key: String, type: StorageType) -> T?
    func remove(forKey key: String, type: StorageType) -> Bool
    func clear(forType type: StorageType) -> Bool
}

extension KeyValueStorage {
    func save(value: String?, forKey key: String) -> Bool {
        return saveObject(value, forKey: key)
    }
    func load(forKey key: String) -> String? {
        return loadObject(forKey: key) as? String
    }
    func save(value: Bool, forKey key: String) -> Bool{
        return saveObject(value, forKey: key)
    }
    func load(forKey key: String) -> Bool? {
        return loadObject(forKey: key) as? Bool
    }
    func save(value: Int, forKey key: String) -> Bool {
        return saveObject(value, forKey: key)
    }
    func load(forKey key:String) -> Int? {
        return loadObject(forKey: key) as? Int
    }
    func save(value: Double, forKey key: String) -> Bool {
        return saveObject(value, forKey: key)
    }
    func load(forKey key: String) -> Double? {
        return loadObject(forKey: key) as? Double
    }
}