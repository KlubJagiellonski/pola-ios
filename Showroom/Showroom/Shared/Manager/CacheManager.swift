import Foundation
import Decodable

protocol Encodable {
    func encode() -> AnyObject
}

class CacheManager {
    func save<T: Encodable>(withCacheName cacheName: String, object: T) throws {
        let fileName = try getCacheFilename(cacheName)
        let data = object.encode()
        let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
        try jsonData.writeToFile(fileName, options: [])
    }
    
    func load<T: Decodable>(fromCacheName cacheName: String) throws -> T? {
        let fileName = try getCacheFilename(cacheName)
        guard let data = NSData(contentsOfFile: fileName) else { return nil }
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        return try T.decode(jsonData)
    }
    
    private func getCacheFilename(filename: String) throws -> String {
        let cachePath = getCachePath()
        try createDirectoriesForPathIfNeeded(cachePath)
        return cachePath + "/" + filename
    }
    
    private func getCachePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths.first!
        return path + "/cache"
    }
    
    private func createDirectoriesForPathIfNeeded(path: String) throws {
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}