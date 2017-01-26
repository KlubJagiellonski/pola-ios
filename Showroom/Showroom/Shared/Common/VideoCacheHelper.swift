import Foundation
import AVFoundation

final class VideoCacheHelper: NSObject, AVAssetResourceLoaderDelegate {
    private let urls: [NSURL]
    private let filenames: [String]
    private let fileManager = NSFileManager.defaultManager()
    
    convenience init(url: NSURL) {
        self.init(urls: [url])
    }
    
    init(urls: [NSURL]) {
        self.urls = urls
        self.filenames = urls.map { String($0.absoluteOrRelativeString.hashValue) + ".mp4" }
    }
    
    func cacheExist(forVideoAtIndex index: Int) -> Bool {
        return cachedFileURL(forVideoAtIndex: index) != nil
    }
    
    func createAsset(forVideoAtIndex index: Int) -> AVURLAsset {
        let url = cachedFileURL(forVideoAtIndex: index) ?? urls[index]
        let asset = AVURLAsset(URL: url)
        asset.resourceLoader.setDelegate(self, queue: dispatch_get_main_queue())
        return asset
    }
    
    func saveToCache(with asset: AVAsset, forVideoAtIndex index: Int) {
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            logError("Cannot create exporter for asset \(asset)")
            return
        }
        
        guard let cachedFileUrl = self.createURLForCacheFile(forVideoAtIndex: index) else {
            logError("Cannot create cached file url \(self.urls[index])")
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
            if exporter.status == .Failed {
                logError("Did fail exporting video with status \(exporter.status.rawValue), error \(exporter.error)")
            } else {
                logError("Exporting video status changed: \(exporter.status.rawValue), error \(exporter.error)")
            }
        }
    }
    
    func clearCache(forVideoAtIndex index: Int) {
        guard let cachedFileUrl = self.createURLForCacheFile(forVideoAtIndex: index) else {
            logError("Cannot create cached file url \(self.urls[index])")
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
    
    private func createURLForCacheFile(forVideoAtIndex index: Int) -> NSURL? {
        do {
            let path = StorageType.Cache.retrieveDirectoryPath()
            try fileManager.createDirectoriesForPathIfNeeded(path)
            return NSURL(fileURLWithPath: path + "/" + filenames[index])
        } catch {
            logInfo("Error while creating url for cache \(error), url: \(urls[index]), filename: \(filenames[index])")
            return nil
        }
    }
    
    private func cachedFileURL(forVideoAtIndex index: Int) -> NSURL? {
        guard let url = createURLForCacheFile(forVideoAtIndex: index), let path = url.path else {
            logError("Cannot create cached file url \(urls[index])")
            return nil
        }
        if fileManager.fileExistsAtPath(path) {
            return url
        } else {
            return nil
        }
    }
}
