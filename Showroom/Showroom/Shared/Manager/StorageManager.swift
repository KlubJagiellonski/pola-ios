import Foundation
import Decodable

private protocol StorageHandler {
    func save<T: Encodable>(name: String, object: T?) -> Bool
    func load<T: Decodable>(name: String) -> T?
    func remove(name: String) -> Bool
    func clear() -> Bool
}

final class StorageManager: KeyValueStorage {
    private let handlers: [StorageType: StorageHandler]
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        handlers = [
            .Persistent:  DriveStorageHandler(type: .Persistent),
            .Cache:  DriveStorageHandler(type: .Cache),
            .PlatformPersistent: DriveStorageHandler(type: .PlatformPersistent)
        ]
    }
    
    func save<T : Encodable>(object: T?, forKey key: String, type: StorageType) -> Bool {
        guard let handler = handlers[type] else {
            logError("Cannot find handler fo type \(type), existing handlers \(handlers)")
            return false
        }
        return handler.save(key, object: object)
    }
    
    func load<T : Decodable>(forKey key: String, type: StorageType) -> T? {
        guard let handler = handlers[type] else {
            logError("Cannot find handler fo type \(type), existing handlers \(handlers)")
            return nil
        }
        return handler.load(key)
    }
    
    func remove(forKey key: String, type: StorageType) -> Bool {
        guard let handler = handlers[type] else {
            logError("Cannot find handler fo type \(type), existing handlers \(handlers)")
            return false
        }
        return handler.remove(key)
    }
    
    func clear(forType type: StorageType) -> Bool {
        guard let handler = handlers[type] else {
            logError("Cannot find handler fo type \(type), existing handlers \(handlers)")
            return false
        }
        return handler.clear()
    }
    
    func loadObject(forKey key: String) -> AnyObject? {
        return userDefaults.objectForKey(key)
    }
    
    func saveObject(object: AnyObject?, forKey key: String) -> Bool {
        userDefaults.setObject(object, forKey: key)
        return userDefaults.synchronize()
    }
}

extension StorageType {
    func retrieveDirectoryPath() -> String {
        switch self {
        case .Cache:
            let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let path = paths.first!
            return path
        case .Persistent:
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let path = paths.first!
            return path + "/data"
        case .PlatformPersistent:
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let path = paths.first!
            return path + "/platformdata"
        }
    }
}

private final class DriveStorageHandler: StorageHandler {
    private let type: StorageType
    
    init(type: StorageType) {
        self.type = type
    }
    
    private func save<T : Encodable>(name: String, object: T?) -> Bool {
        do {
            let path = try retrievePath(forFilename: name, type: type)
            try saveData(path, object: object)
            return true
        } catch {
            logError("Cannot save data for name \(name), type \(type), \(error)")
            return false
        }
    }
    
    private func load<T : Decodable>(name: String) -> T? {
        do {
            let path = try retrievePath(forFilename: name, type: type)
            return try loadData(path)
        } catch {
            logError("Cannot load data for name \(name), type \(type), \(error)")
            return nil
        }
    }
    
    private func clear() -> Bool {
        let fileManager = NSFileManager.defaultManager()
        do {
            let path = type.retrieveDirectoryPath()
            try createDirectoriesForPathIfNeeded(path)
            for file in try fileManager.contentsOfDirectoryAtPath(path) {
                try fileManager.removeItemAtPath(file)
            }
            return true
        } catch {
            logError("Cannot clear data with type \(type), \(error)")
            return false
        }
    }
    
    private func remove(name: String) -> Bool {
        do {
            let path = try retrievePath(forFilename: name, type: type)
            try removeFile(atPath: path)
            return true
        } catch {
            logError("Cannot remove data with type \(type), name \(name), error \(error)")
            return false
        }
    }
    
    private func saveData<T: Encodable>(path: String, object: T?) throws {
        logInfo("Saving to path \(path) empty object \(object == nil)")
        guard let object = object else {
            try removeFile(atPath: path)
            return
        }
        let data = object.encode()
        let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
        try jsonData.writeToFile(path, options: [])
    }
    
    private func loadData<T: Decodable>(path: String) throws -> T? {
        logInfo("Loading data \(path)")
        guard let data = NSData(contentsOfFile: path) else { return nil }
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        return try T.decode(jsonData)
    }
    
    private func retrievePath(forFilename filename: String, type: StorageType) throws -> String {
        let directoryPath = type.retrieveDirectoryPath()
        try createDirectoriesForPathIfNeeded(directoryPath)
        return directoryPath + "/" + filename
    }
    
    private func createDirectoriesForPathIfNeeded(path: String) throws {
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func removeFile(atPath path: String) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path) {
            try fileManager.removeItemAtPath(path)
        }
    }
    
}