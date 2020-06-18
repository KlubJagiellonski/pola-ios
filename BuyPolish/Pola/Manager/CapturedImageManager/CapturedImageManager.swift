import UIKit

protocol CapturedImageManager {
    func addImage(_ image: UIImage)
    func retrieveImagesData() -> [Data]
    func removeImages()
    var imagesCount: Int { get }
}
