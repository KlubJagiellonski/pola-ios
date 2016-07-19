import Foundation
import Decodable

protocol Encodable {
    func encode() -> AnyObject
}

class StorageManager {
    func save<T: Encodable>(name: String, object: T?) throws {
        try saveData(getPersistentPath(forFilename: name), object: object)
    }
    
    func saveToCache<T: Encodable>(cacheName: String, object: T?) throws {
        try saveData(getCachePath(forFilename: cacheName), object: object)
    }
    
    func load<T: Decodable>(name: String) throws -> T? {
        return try loadData(getPersistentPath(forFilename: name))
    }
    
    func loadFromCache<T: Decodable>(cacheName: String) throws -> T? {
        return try loadData(getCachePath(forFilename: cacheName))
    }
    
    private func saveData<T: Encodable>(path: String, object: T?) throws {
        guard let object = object else {
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                try fileManager.removeItemAtPath(path)
            }
            return
        }
        let data = object.encode()
        let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
        try jsonData.writeToFile(path, options: [])
    }
    
    private func loadData<T: Decodable>(path: String) throws -> T? {
        guard let data = NSData(contentsOfFile: path) else { return nil }
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        return try T.decode(jsonData)
    }
    
    private func getPersistentPath(forFilename filename: String) throws -> String {
        let persistentPath = getPersistentDirectoryPath()
        try createDirectoriesForPathIfNeeded(persistentPath)
        return persistentPath + "/" + filename
    }
    
    private func getCachePath(forFilename filename: String) throws -> String {
        let cachePath = getCacheDirectoryPath()
        try createDirectoriesForPathIfNeeded(cachePath)
        return cachePath + "/" + filename
    }
    
    private func getPersistentDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths.first!
        return path + "/data"
    }
    
    private func getCacheDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths.first!
        return path
    }
    
    private func createDirectoriesForPathIfNeeded(path: String) throws {
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}