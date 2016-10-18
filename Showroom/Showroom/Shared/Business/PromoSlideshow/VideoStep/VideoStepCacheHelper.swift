import Foundation
import AVFoundation

final class VideoStepCacheHelper: NSObject, AVAssetResourceLoaderDelegate {
    private let url: NSURL
    private let filename: String
    private let fileManager = NSFileManager.defaultManager()
    var cachedFileUrl: NSURL? {
        guard let url = createURLForCacheFile(), let path = url.path else {
            logError("Cannot create cached file url \(self.url)")
            return nil
        }
        if fileManager.fileExistsAtPath(path) {
            return url
        } else {
            return nil
        }
    }
    
    init(url: NSURL) {
        self.url = url
        self.filename = String(url.absoluteString.hashValue) + ".mp4"
    }
    
    func saveToCache(with asset: AVAsset) {
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            logError("Cannot create exporter for asset \(asset)")
            return
        }
        
        guard let cachedFileUrl = self.createURLForCacheFile() else {
            logError("Cannot create cached file url \(self.url)")
            return
        }
        
        guard let path = cachedFileUrl.path where !fileManager.fileExistsAtPath(path) else {
            logInfo("File already exist at url \(cachedFileUrl)")
            return
        }
        
        logInfo("Saving to url \(cachedFileUrl)")
        
        exporter.outputURL = cachedFileUrl
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.exportAsynchronouslyWithCompletionHandler {
            logError("Did end exporting vide with status \(exporter.status.rawValue), error \(exporter.error)")
        }
    }
    
    func clearCache() {
        guard let cachedFileUrl = self.createURLForCacheFile() else {
            logError("Cannot create cached file url \(self.url)")
            return
        }
        guard let path = cachedFileUrl.path where fileManager.fileExistsAtPath(path) else {
            logInfo("File already exist at url \(cachedFileUrl)")
            return
        }
        logInfo("Removing file for path \(path)")
        do {
            try fileManager.removeItemAtPath(path)
        } catch {
            logError("Could not remove item at path \(path)")
        }
    }
    
    private func createURLForCacheFile() -> NSURL? {
        do {
            let path = StorageType.Cache.retrieveDirectoryPath()
            try fileManager.createDirectoriesForPathIfNeeded(path)
            return NSURL(fileURLWithPath: path + "/" + filename)
        } catch {
            logInfo("Error while creating url for cache \(error), url: \(url), filename: \(filename)")
            return nil
        }
    }
}
