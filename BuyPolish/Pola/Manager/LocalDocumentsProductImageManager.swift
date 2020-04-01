import UIKit

final class LocalDocumentsProductImageManager : ProductImageManager {
    
    private let mainDirectory = "LocalFilesProductImageManager"
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func saveImage(_ image: UIImage, for key: ReportProblemReason, index: Int) -> Bool {
        let id = newImageId(for: key)
        guard createDirIfNeeded(path: fullPath(relativePath: key.pathToDirectoryWithImages(with: id))) else {
            return false
        }
        return saveImage(image, for: key, id: id, size: .big) && saveImage(image, for: key, id: id, size: .thumbnail)
    }
    
    func removeImage(for key: ReportProblemReason, index: Int) -> Bool {
        let id = idForImage(for: key, index: index)
        let path = fullPath(relativePath: key.pathToDirectoryWithImages(with: id))
        return removeItem(atPath: path)
    }
    
    func removeImages(for key: ReportProblemReason) -> Bool {
        removeItem(atPath: fullPath(relativePath: key.directoryName))
    }
    
    func retrieveThumbnail(for key: ReportProblemReason, index: Int) -> UIImage? {
        retrieveThumbnail(for: key, id: idForImage(for: key, index: index))
    }
    
    func retrieveThumbnails(for key: ReportProblemReason) -> [UIImage] {
        imageIds(for: key).compactMap({retrieveThumbnail(for: key, id: $0)})
    }
    
    func pathsForImages(for key: ReportProblemReason) -> [String] {
        imageIds(for: key)
            .map({key.pathToImage(id: $0, size: .big)})
            .map({fullPath(relativePath: $0)})
    }
    
    private func removeItem(atPath path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            return false
        }
        return true
    }
    
    private func saveImage(_ image: UIImage, for key: ReportProblemReason, id: Int, size: ProductImageSize) -> Bool {
        saveImage(image.scaled(to: size), path: fullPath(relativePath: key.pathToImage(id: id, size: size)))
    }
    
    private func saveImage(_ image: UIImage, path: String) -> Bool {
        guard let data = image.pngData() else {
            return false
        }
        
        return fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    private func retrieveThumbnail(for key: ReportProblemReason, id: Int) -> UIImage? {
        let path = fullPath(relativePath: key.pathToImage(id: id, size: .thumbnail))
        guard let data = fileManager.contents(atPath: path),
            let image = UIImage(data: data) else {
                return nil
        }
        return image
    }
    
    private func imageIds(for key: ReportProblemReason) -> [Int] {
        let path = fullPath(relativePath: key.directoryName)
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDir),
            isDir.boolValue,
            let contents = try? fileManager.contentsOfDirectory(atPath: path) else {
                return []
        }
        
        return contents
            .filter({fileManager.isDirectory(path: path.appending("/\($0)"))})
            .compactMap({Int($0)})
            .sorted()
    }
    
    private func newImageId(for key: ReportProblemReason) -> Int {
        guard let last = imageIds(for: key).last else {
            return 0
        }
        return last + 1
    }
    
    private func idForImage(for key: ReportProblemReason, index: Int) -> Int {
        imageIds(for: key)[index]
    }
    
    private var mainDirectoryPath: String {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .last!
            .path
            .appending("/\(mainDirectory)")
        
    }
    
    private func fullPath(relativePath: String) -> String {
        "\(mainDirectoryPath)/\(relativePath)"
    }
    
    private func createDirIfNeeded(path: String) -> Bool {
        if fileManager.fileExists(atPath: path) {
            return true
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return false
        }
        return true
    }
    
}

fileprivate enum ProductImageSize: String {
    case big
    case thumbnail
    
    var widht: CGFloat {
        switch self {
        case .big:
            return 800.0
        case .thumbnail:
            return 200.0
        }
    }
}

fileprivate extension ReportProblemReason {
    var directoryName: String {
        switch self {
        case .general:
            return "general"
        case .product(let productId, _):
            return "\(productId)"
        }
    }
    
    func pathToDirectoryWithImages(with id: Int) -> String{
        "\(directoryName)/\(id)"
    }
    
    func pathToImage(id: Int, size: ProductImageSize) -> String{
        "\(pathToDirectoryWithImages(with: id))/\(size.rawValue).png"
    }
    
}

fileprivate extension UIImage {
    func data(for imageSize: ProductImageSize) -> Data? {
        self.scaled(toWidth: imageSize.widht).pngData()
    }
    
    func scaled(to imageSize: ProductImageSize) -> UIImage {
        return self.scaled(toWidth: imageSize.widht)
    }
}
