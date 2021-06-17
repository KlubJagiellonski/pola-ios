@testable import Pola
import UIKit

class MockProductImageManager: ProductImageManager {
    func saveImage(_: UIImage, for _: ReportProblemReason, index _: Int) -> Bool {
        return false
    }

    func removeImage(for _: ReportProblemReason, index _: Int) -> Bool {
        return false
    }

    func removeImages(for _: ReportProblemReason) -> Bool {
        return false
    }

    func retrieveThumbnail(for _: ReportProblemReason, index _: Int) -> UIImage? {
        return nil
    }

    func retrieveThumbnails(for _: ReportProblemReason) -> [UIImage] {
        return []
    }

    func pathsForImages(for _: ReportProblemReason) -> [String] {
        return []
    }
}
