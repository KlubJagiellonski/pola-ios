import Foundation

extension NSFileManager {
    func createDirectoriesForPathIfNeeded(path: String) throws {
        if !fileExistsAtPath(path) {
            try createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
