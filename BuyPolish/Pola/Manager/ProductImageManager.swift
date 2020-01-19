import Foundation

enum ProductImageManagerError : Error {
    case convertDataToImage
    case convertImageToData
}

protocol ProductImageManager {
    func saveImage(_ image: UIImage, for key: RaportProblemReason, index: Int) -> Bool
    func removeImage(for key: RaportProblemReason, index: Int) -> Bool
    func removeImages(for key: RaportProblemReason) -> Bool
    func retrieveThumbnail(for key: RaportProblemReason, index: Int) -> UIImage?
    func retrieveThumbnails(for key: RaportProblemReason) -> [UIImage]
    func pathsForImages(for key: RaportProblemReason) -> [String]
}
