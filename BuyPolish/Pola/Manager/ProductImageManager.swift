import UIKit

enum ProductImageManagerError : Error {
    case convertDataToImage
    case convertImageToData
}

protocol ProductImageManager {
    func saveImage(_ image: UIImage, for key: ReportProblemReason, index: Int) -> Bool
    func removeImage(for key: ReportProblemReason, index: Int) -> Bool
    func removeImages(for key: ReportProblemReason) -> Bool
    func retrieveThumbnail(for key: ReportProblemReason, index: Int) -> UIImage?
    func retrieveThumbnails(for key: ReportProblemReason) -> [UIImage]
    func pathsForImages(for key: ReportProblemReason) -> [String]
}
